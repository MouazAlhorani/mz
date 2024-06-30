import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_tak_app/controllers/remindsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/reminder_model.dart';
import 'package:mz_tak_app/models/textfield_model.dart';
import 'package:mz_tak_app/widgets/textfield_card.dart';
import 'package:intl/intl.dart' as df;
import 'package:provider/provider.dart';

class RemindsEdit extends StatefulWidget {
  RemindsEdit({super.key, this.editmode = false, this.data});
  static const String routename = "/homepage/reminds/remindedit";
  bool editmode;
  ReminderModel? data;
  int x = 0;
  @override
  State<RemindsEdit> createState() => _RemindsEditState();
}

class _RemindsEditState extends State<RemindsEdit> {
  bool autotype = true, notifi = true;
  DateTime? expiredate = DateTime.now();
  List<TextFieldModel> editelements = [
    TextFieldModel(
      controller: TextEditingController(),
      label: "الاسم",
      validate: (x) {
        if (x != null && x.trim().isEmpty) {
          return "لا يمكن ان يكون اسم التذكير فارغا";
        }
      },
    ),
    TextFieldModel(
        controller: TextEditingController(),
        label: "التفاصيل",
        lines: 5,
        inputtype: TextInputType.multiline),
    TextFieldModel(
        controller: TextEditingController(),
        label: "التذكير قبل",
        inputtype: TextInputType.number,
        validate: (x) {
          if (x != null && int.tryParse(x) != null) {
            return null;
          } else {
            return "أدخل قيمة عددية صحيحة";
          }
        }),
    TextFieldModel(
        controller: TextEditingController(),
        label: "url",
        direction: TextDirection.ltr)
  ];
  @override
  void dispose() {
    for (var i in editelements) {
      i.controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    widget.data = ModalRoute.of(context)!.settings.arguments as ReminderModel?;
    if (widget.data != null) {
      widget.editmode = true;
      if (widget.x == 0) {
        autotype = widget.data!.type == "auto" ? true : false;
        editelements[0].controller.text = widget.data!.name;
        editelements[1].controller.text = widget.data!.desc.toString();
        editelements[2].controller.text = widget.data!.remindbefor.toString();
        editelements[3].controller.text = widget.data!.url.toString();
        editelements.last.visible = widget.data!.type == "auto" ? true : false;
        notifi = widget.data!.notifi;
        expiredate = widget.data!.expire;
      }
    }
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    editelements.last.validate = (x) {
      if (autotype) {
        if (x == null || x.isEmpty) {
          return "لا يمكن ان يكون العنوان فارغا";
        } else if (!x.toString().toLowerCase().startsWith("https://")) {
          return "يجب أن يبدأ العنوان بهذه الدالة https://";
        }
      }
    };

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editmode ? "تعديل" : "إضافة تذكير جديد"),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("جلب معلومات التذكير"),
                            Switch(
                                value: autotype,
                                onChanged: (x) {
                                  setState(() {
                                    autotype = x;
                                    editelements.last.visible = x;
                                    widget.x = 1;
                                  });
                                }),
                            Text(autotype ? "تلقائي" : "يدوي")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Switch(
                                value: notifi,
                                onChanged: (x) {
                                  setState(() {
                                    notifi = x;
                                    widget.x = 1;
                                  });
                                }),
                            Text(notifi ? "الاشعار مفعل" : "الاشعار معطل")
                          ],
                        ),
                      ),
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
                      Visibility(
                        visible: !autotype,
                        child: SizedBox(
                          width: 500,
                          child: Row(
                            children: [
                              Text("تاريخ التذكير"),
                              TextButton.icon(
                                  onPressed: () async {
                                    DateTime? date = await showDatePicker(
                                        context: context,
                                        initialDate:
                                            expiredate ?? DateTime.now(),
                                        firstDate: DateTime.now()
                                            .add(Duration(days: -100)),
                                        lastDate: DateTime.now()
                                            .add(Duration(days: 5000)));
                                    if (date != null) {
                                      setState(() {
                                        widget.x = 1;
                                        expiredate = date;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.date_range_outlined),
                                  label: Text(
                                    expiredate == null
                                        ? "غير محدد"
                                        : df.DateFormat("yyyy-MM-dd HH:mm")
                                            .format(expiredate!),
                                    textDirection: TextDirection.ltr,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 500, child: Divider()),
                      TextButton.icon(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              if (widget.editmode) {
                                var resp = await requestupdate(
                                    endpoint: "reminds/update",
                                    body: {
                                      "id": widget.data!.id.toString(),
                                      "remindname":
                                          editelements[0].controller.text,
                                      "reminddesc":
                                          editelements[1].controller.text,
                                      "remindbefor":
                                          editelements[2].controller.text,
                                      "url": editelements[3].controller.text,
                                      "expiredate": expiredate == null
                                          ? ''
                                          : df.DateFormat("yyyy-MM-dd HH:mm")
                                              .format(expiredate!),
                                      "type": autotype ? "auto" : "man",
                                      "notifi": notifi ? "1" : "0"
                                    });
                                if (resp != null) {
                                  context
                                      .read<RemindsListProvider>()
                                      .updatelist(
                                          id: widget.data!.id,
                                          newdata: ReminderModel.fromdata(
                                              data: resp));
                                }
                              } else {
                                var resp = await requestpost(
                                    endpoint: "reminds/add",
                                    body: {
                                      "remindname":
                                          editelements[0].controller.text,
                                      "reminddesc":
                                          editelements[1].controller.text,
                                      "remindbefor":
                                          editelements[2].controller.text,
                                      "url": editelements[3].controller.text,
                                      "expiredate": expiredate == null
                                          ? ''
                                          : df.DateFormat("yyyy-MM-dd HH:mm")
                                              .format(expiredate!),
                                      "type": autotype ? "auto" : "man",
                                      "notifi": notifi ? "1" : "0"
                                    });

                                if (resp != null) {
                                  context.read<RemindsListProvider>().additem(
                                      newdata:
                                          ReminderModel.fromdata(data: resp));
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
