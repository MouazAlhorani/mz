import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/pages/help/helps_edit.dart';
import 'package:provider/provider.dart';

class HelpCard extends StatefulWidget {
  const HelpCard(
      {super.key, required this.helpname, this.helpdesc, required this.data});

  final String helpname;
  final String? helpdesc;
  final HelpModel data;
  @override
  State<HelpCard> createState() => _HelpCardState();
}

class _HelpCardState extends State<HelpCard> {
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
                  widget.helpname,
                  textDirection: widget.helpname
                          .toString()
                          .contains(RegExp(r'^[a-zA-Z]+$'), 1)
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                ),
                content: Column(
                  children: [
                    widget.helpdesc == null
                        ? SizedBox()
                        : SelectableText(
                            widget.helpdesc.toString(),
                            textDirection: widget.helpdesc
                                    .toString()
                                    .contains(RegExp(r'^[a-zA-Z]+$'))
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, HelpsEdit.routename,
                            arguments: widget.data);
                      },
                      child: Text("تعديل")),
                  TextButton(
                      onPressed: () async {
                        await requestdelete(
                            endpoint: "helps/delete",
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
              title: Text(widget.helpname),
              subtitle: widget.helpdesc == null
                  ? null
                  : Text(widget.helpdesc.toString().length > 35
                      ? "${widget.helpdesc.toString().substring(0, 35)} ..."
                      : widget.helpdesc.toString()),
            ),
          ),
        ),
      ),
    );
  }
}
