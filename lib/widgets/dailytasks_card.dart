import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/pages/dailytask/dailytasks_edit.dart';
import 'package:provider/provider.dart';

class DailyTasksCard extends StatefulWidget {
  const DailyTasksCard(
      {super.key,
      required this.task,
      this.taskhelp,
      required this.data,
      this.helps});

  final String task;
  final HelpModel? taskhelp;
  final DailyTaskModel data;
  final List<HelpModel>? helps;
  @override
  State<DailyTasksCard> createState() => _DailyTasksCardState();
}

class _DailyTasksCardState extends State<DailyTasksCard> {
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
                title: Text(
                  widget.task,
                  textDirection:
                      widget.task.toString().contains(RegExp(r'^[a-zA-Z]+$'), 1)
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                ),
                content: Column(
                  children: [
                    widget.taskhelp == null
                        ? SizedBox()
                        : SelectableText(
                            widget.taskhelp!.helpname.toString(),
                          ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, DailyTasksEdit.routename, arguments: {
                          "data": widget.data,
                          "helps": widget.helps
                        });
                      },
                      child: Text("تعديل")),
                  TextButton(
                      onPressed: () async {
                        await requestdelete(
                            endpoint: "dailytasks/delete",
                            body: {"id": widget.data.id.toString()});
                        context
                            .read<HelpsListProvider>()
                            .delete(id: widget.data.id);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "حذف",
                        style: TextStyle(color: Colors.red),
                      ))
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
              title: Text(widget.task),
              subtitle: widget.taskhelp == null
                  ? null
                  : Text(widget.taskhelp!.helpname.toString().length > 35
                      ? "${widget.taskhelp!.helpname.toString().substring(0, 35)} ..."
                      : widget.taskhelp!.helpname.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
