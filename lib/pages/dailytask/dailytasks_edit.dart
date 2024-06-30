import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/dailytasksProvider.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';
import 'package:provider/provider.dart';

class DailyTasksEdit extends StatefulWidget {
  static const String routename = "/homepage/dailytasks/edit";

  DailyTasksEdit({super.key, this.editmode = false, this.data, this.helps});
  bool editmode;
  DailyTaskModel? data;
  int x = 0;
  List<HelpModel>? helps;

  @override
  State<DailyTasksEdit> createState() => _DailyTasksEditState();
}

class _DailyTasksEditState extends State<DailyTasksEdit> {
  List<TextFieldModel> editelements = [
    TextFieldModel(
      controller: TextEditingController(),
      lines: 5,
      inputtype: TextInputType.multiline,
      label: "المهمة",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون اسم المهمة فارغا";
        }
      },
    ),
  ];
  @override
  void dispose() {
    for (var i in editelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  HelpModel? helpsvalue;
  bool connecthelp = false;
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    if (args != null) {
      widget.data = args['data'];
      if (args['helps'] != null) {
        widget.helps = args['helps'];
      }
    }

    if (widget.data != null) {
      widget.editmode = true;
      if (widget.x == 0) {
        editelements[0].controller.text = widget.data!.task;
        if (widget.helps!.isNotEmpty) {
          helpsvalue = widget.helps![0];
        }
        if (widget.data!.taskhelp == null) {
          connecthelp = false;
        } else {
          connecthelp = true;
        }
      }
    }
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editmode ? "تعديل" : "إضافة مهمة جديدة"),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  helpsvalue != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Switch(
                                value: connecthelp,
                                onChanged: (x) {
                                  setState(() {
                                    widget.x = 1;
                                    connecthelp = x;
                                  });
                                }),
                            Text("ربط مع ملف مساعد"),
                            Visibility(
                              visible: connecthelp,
                              child: DropdownButton(
                                  value: helpsvalue!.helpname,
                                  items: widget.helps!
                                      .map((e) => DropdownMenuItem(
                                          value: e.helpname,
                                          child: Text(e.helpname)))
                                      .toList(),
                                  onChanged: (x) {
                                    setState(() {
                                      widget.x = 1;
                                      helpsvalue = widget.helps!
                                          .where((element) =>
                                              element.helpname == x)
                                          .first;
                                    });
                                  }),
                            ),
                          ],
                        )
                      : SizedBox(),
                  Form(
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
                                        endpoint: "dailytasks/update",
                                        body: {
                                          "id": widget.data!.id.toString(),
                                          "task":
                                              editelements[0].controller.text,
                                          "taskhelpid": connecthelp
                                              ? helpsvalue!.id.toString()
                                              : ""
                                        });
                                    if (resp != null) {
                                      print(resp);
                                      context
                                          .read<DailyTasksListProvider>()
                                          .updatelist(
                                              id: widget.data!.id,
                                              newdata: DailyTaskModel.fromdata(
                                                  helps: widget.helps,
                                                  data: resp));
                                    }
                                  } else {
                                    var resp = await requestpost(
                                        endpoint: "dailytasks/add",
                                        body: {
                                          "task":
                                              editelements[0].controller.text,
                                          "taskhelpid": connecthelp
                                              ? helpsvalue!.id.toString()
                                              : ""
                                        });

                                    if (resp != null) {
                                      context
                                          .read<DailyTasksListProvider>()
                                          .additem(
                                              newdata: DailyTaskModel.fromdata(
                                                  helps: widget.helps,
                                                  data: resp));
                                    }
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: Icon(Icons.save),
                              label: Text("حفظ"))
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
