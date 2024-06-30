import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/dailytasksreportsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';
import 'package:provider/provider.dart';

class DailyTasksReportsEdit extends StatefulWidget {
  DailyTasksReportsEdit({super.key, this.editmode = false, this.data});
  static const String routename = "/homepage/dailytasksreport/edit";
  bool editmode;
  DailyTasksReportModel? data;
  int x = 0;
  @override
  State<DailyTasksReportsEdit> createState() => _DailyTasksreportsEditState();
}

class _DailyTasksreportsEditState extends State<DailyTasksReportsEdit> {
  List<TextFieldModel> editelements = [];
  @override
  void dispose() {
    for (var i in editelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    widget.data =
        ModalRoute.of(context)!.settings.arguments as DailyTasksReportModel?;
    if (widget.data != null) {
      widget.editmode = true;
      if (widget.x == 0) {}
    }
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editmode ? "تعديل" : "إضافة تقرير جديد"),
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
                              var resp = await requestpost(
                                  endpoint: "dailytasksreports/add", body: {});

                              if (resp != null) {
                                context
                                    .read<DailyTasksReportsListProvider>()
                                    .additem(
                                        newdata: DailyTasksReportModel.fromdata(
                                            data: resp));
                              }
                            }
                            Navigator.of(context).pop();
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
