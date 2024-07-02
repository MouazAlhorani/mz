import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_tak_app/controllers/dailytasksreportsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:intl/intl.dart' as df;
import 'package:provider/provider.dart';

class DailyTasksReportsEdit extends StatelessWidget {
  static const String routename = "/homepage/dailytasksreport/edit";

  DailyTasksReportsEdit({super.key});
  List<DailyTaskModel>? dailytasks = [];
  List<HelpModel>? helps = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: Future(() async {
      var h = await requestpost(endpoint: "helps/getdata");
      var d = await requestpost(endpoint: "dailytasks/getdata");
      if (h != null) {
        for (var i in h) {
          helps!.add(HelpModel.fromdata(data: i));
        }
      }
      if (d != null) {
        for (var i in d) {
          dailytasks!.add(DailyTaskModel.fromdata(helps: helps, data: i));
        }
      }
    }), builder: (_, s) {
      if (s.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        List editelement = [];
        editelement.clear();
        for (var i in dailytasks!) {
          editelement.add({
            'checkbox': false,
            'task': i.task,
            'taskhelp': i.taskhelp,
            'comment': TextEditingController(),
            'commentvisible': false
          });
        }
        return DTREdit(data: editelement);
      }
    });
  }
}

class DTREdit extends StatefulWidget {
  DTREdit({super.key, this.data});
  final List? data;

  @override
  State<DTREdit> createState() => _DTREditState();
}

class _DTREditState extends State<DTREdit> {
  @override
  void dispose() {
    for (var i in widget.data!) {
      i['comment'].dispose();
    }
    maincomment.dispose();
    super.dispose();
  }

  TextEditingController maincomment = TextEditingController();
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("إضافة تقرير جديد"),
            centerTitle: true,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...widget.data!.map((e) => SizedBox(
                              width: 600,
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Checkbox(
                                          value: e['checkbox'],
                                          onChanged: (x) {
                                            setState(() {
                                              e['checkbox'] = x;
                                            });
                                          }),
                                      title: Text(e['task'].toString()),
                                      subtitle: e['taskhelp'] == null
                                          ? null
                                          : Align(
                                              alignment: Alignment.topLeft,
                                              child: IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return AlertDialog(
                                                              title: Text(
                                                                e['taskhelp']
                                                                    .helpname,
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                              ),
                                                              content: Text(
                                                                  e['taskhelp']
                                                                          .helpdesc ??
                                                                      ""));
                                                        });
                                                  },
                                                  icon: Icon(Icons.help)),
                                            ),
                                      trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              e['commentvisible'] =
                                                  !e['commentvisible'];
                                            });
                                          },
                                          icon:
                                              Icon(Icons.add_comment_rounded)),
                                    ),
                                    Visibility(
                                        visible: e['commentvisible'],
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder()),
                                            textAlign: TextAlign.center,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                            controller: e['comment'],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 600,
                          child: TextField(
                            controller: maincomment,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                InputDecoration(label: Text("تعليق عام")),
                          ),
                        ),
                        SizedBox(width: 500, child: Divider()),
                        TextButton.icon(
                            onPressed: () async {
                              String report = "";
                              for (var i in widget.data!) {
                                if (i['checkbox']) {
                                  report += "<DONE>${i['task']}\n";
                                  i['commentvisible']
                                      ? report += "${i['comment'].text}\n"
                                      : "";
                                } else if (!i['checkbox']) {
                                  report += "<NO>${i['task']}\n";
                                  i['commentvisible']
                                      ? report += "${i['comment'].text}\n"
                                      : "";
                                }
                              }
                              report += maincomment.text;
                              if (_formkey.currentState!.validate()) {
                                var resp = await requestpost(
                                    endpoint: "dailytasksreports/add",
                                    body: {
                                      "report": report,
                                      "reportdate":
                                          df.DateFormat("yyyy-MM-dd HH:mm")
                                              .format(DateTime.now()),
                                      "createby": userinfosharedpref!
                                          .getStringList("userinfo")![2],
                                      "createby_id": userinfosharedpref!
                                          .getStringList("userinfo")![0],
                                    });

                                if (resp != null) {
                                  context
                                      .read<DailyTasksReportsListProvider>()
                                      .additem(
                                          newdata:
                                              DailyTasksReportModel.fromdata(
                                                  data: resp));
                                }
                              }
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.save),
                            label: Text("حفظ"))
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
