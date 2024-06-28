import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as df;
import 'package:mz_tak_app/models/reminder_model.dart';
import 'package:mz_tak_app/pages/reminder/reminds_edit.dart';

class ReminderCard extends StatefulWidget {
  const ReminderCard(
      {super.key,
      required this.name,
      this.expire,
      this.timetoexpire,
      this.alert = false,
      required this.data});
  final bool alert;
  final String name;
  final DateTime? expire;
  final String? timetoexpire;
  final ReminderModel data;
  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  double coverwidth = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (_) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  scrollable: true,
                  title: Text(
                    widget.data.name,
                    textDirection: widget.data.name
                            .toString()
                            .contains(RegExp(r'^[a-zA-Z]+$'), 1)
                        ? TextDirection.ltr
                        : TextDirection.rtl,
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.desc.toString()),
                      widget.data.expire == null
                          ? SizedBox()
                          : Text(
                              df.DateFormat("yyyy-MM-dd HH:mm")
                                  .format(widget.data.expire!),
                              textDirection: TextDirection.ltr,
                            ),
                      widget.data.timetoexpire == null
                          ? SizedBox()
                          : Text(widget.data.timetoexpire!,
                              textDirection: TextDirection.ltr),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, RemindsEdit.routename,
                              arguments: widget.data);
                        },
                        child: Text("تعديل"))
                  ],
                ),
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
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: widget.alert ? Colors.red : Colors.green,
                          width: 3))),
              child: ListTile(
                mouseCursor: SystemMouseCursors.click,
                leading: Icon(
                  widget.alert ? Icons.warning_amber_outlined : Icons.check,
                  color: widget.alert ? Colors.red : Colors.green,
                ),
                title: Text(widget.name),
                subtitle: widget.expire == null
                    ? null
                    : Text(
                        df.DateFormat("yyyy-MM-dd HH:mm")
                            .format(widget.expire!),
                        textDirection: TextDirection.ltr,
                      ),
                trailing: widget.timetoexpire == null
                    ? null
                    : Text(
                        "${widget.timetoexpire}",
                        style: TextStyle(fontSize: 15),
                        textDirection: TextDirection.ltr,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
