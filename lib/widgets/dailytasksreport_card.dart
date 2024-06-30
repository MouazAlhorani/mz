import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports_edit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as df;

class DailyTasksReportCard extends StatefulWidget {
  const DailyTasksReportCard({
    super.key,
    required this.report,
    required this.reportdate,
    required this.createby,
    this.createby_id,
    required this.data,
  });

  final String report, createby;
  final DateTime reportdate;
  final int? createby_id;
  final DailyTasksReportModel data;

  @override
  State<DailyTasksReportCard> createState() => _DailyTasksReportCardState();
}

class _DailyTasksReportCardState extends State<DailyTasksReportCard> {
  double coverwidth = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                scrollable: true,
                title: Text(widget.createby),
                content: Column(
                  children: [
                    Row(
                      children: [
                        Text(widget.createby),
                        Spacer(),
                        Text(
                          df.DateFormat("yyyy-MM-dd HH:mm")
                              .format(widget.reportdate),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    Divider(),
                    SelectableText(
                      widget.report.toString(),
                    ),
                  ],
                ),
                actions: [
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.pushReplacementNamed(
                  //           context, DailyTasksReportsEdit.routename,
                  //           arguments: {
                  //             "data": widget.data,
                  //           });
                  //     },
                  //     child: Text("تعديل")),
                  // TextButton(
                  //     onPressed: () async {
                  //       await requestdelete(
                  //           endpoint: "dailytasksreports/delete",
                  //           body: {"id": widget.data.id.toString()});
                  //       context
                  //           .read<HelpsListProvider>()
                  //           .delete(id: widget.data.id);
                  //       Navigator.pop(context);
                  //     },
                  //     child: Text(
                  //       "حذف",
                  //       style: TextStyle(color: Colors.red),
                  //     ))
                ],
              );
            });
      },
      child: MouseRegion(
        onHover: (event) => setState(() {
          coverwidth = 500;
        }),
        onExit: (event) => setState(() {
          coverwidth = 0;
        }),
        child: SizedBox(
          width: 600,
          child: Card(
            color: coverwidth == 500 ? Colors.amber[100] : Colors.white,
            child: ListTile(
              mouseCursor: SystemMouseCursors.click,
              title: Row(
                children: [
                  Text(widget.createby),
                  Spacer(),
                  Text(
                    df.DateFormat("yyyy-MM-dd HH:mm").format(widget.reportdate),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),
              subtitle: Text(widget.report.toString().length > 35
                  ? "${widget.report.toString().substring(0, 35)} ..."
                  : widget.report.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
