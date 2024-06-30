import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';
import 'package:provider/provider.dart';

class HelpsEdit extends StatefulWidget {
  HelpsEdit({super.key, this.editmode = false, this.data});
  static const String routename = "/homepage/helps/edit";
  bool editmode;
  HelpModel? data;
  int x = 0;
  @override
  State<HelpsEdit> createState() => _HelpsEditState();
}

class _HelpsEditState extends State<HelpsEdit> {
  List<TextFieldModel> editelements = [
    TextFieldModel(
      controller: TextEditingController(),
      label: "الاسم",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون اسم الملف فارغا";
        }
      },
    ),
    TextFieldModel(
        controller: TextEditingController(),
        label: "التفاصيل",
        lines: 5,
        inputtype: TextInputType.multiline),
  ];
  @override
  void dispose() {
    for (var i in editelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    widget.data = ModalRoute.of(context)!.settings.arguments as HelpModel?;
    if (widget.data != null) {
      widget.editmode = true;
      if (widget.x == 0) {
        editelements[0].controller.text = widget.data!.helpname;
        editelements[1].controller.text = widget.data!.helpdesc.toString();
      }
    }
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editmode ? "تعديل" : "إضافة ملف جديد"),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      ...editelements
                          .where((element) => element.visible)
                          .map((e) => TextFieldCard(
                                label: e.label,
                                controller: e.controller,
                                inputType: e.inputtype,
                                maxlines: e.lines,
                                validate: e.validate,
                                direction: e.direction,
                              )),
                      SizedBox(width: 500, child: Divider()),
                      TextButton.icon(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              if (widget.editmode) {
                                var resp = await requestupdate(
                                    endpoint: "helps/update",
                                    body: {
                                      "id": widget.data!.id.toString(),
                                      "helpname":
                                          editelements[0].controller.text,
                                      "helpdesc":
                                          editelements[1].controller.text,
                                    });
                                if (resp != null) {
                                  context.read<HelpsListProvider>().updatelist(
                                      id: widget.data!.id,
                                      newdata: HelpModel.fromdata(data: resp));
                                }
                              } else {
                                var resp = await requestpost(
                                    endpoint: "helps/add",
                                    body: {
                                      "helpname":
                                          editelements[0].controller.text,
                                      "helpdesc":
                                          editelements[1].controller.text,
                                    });

                                if (resp != null) {
                                  context.read<HelpsListProvider>().additem(
                                      newdata: HelpModel.fromdata(data: resp));
                                }
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("حفظ"))
                    ],
                  )),
            ),
          ),
        ));
  }
}
