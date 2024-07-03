import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';
import 'package:mz_tak_app/models/account_model.dart';
import 'package:mz_tak_app/pages/accounts/accounts_edit.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as df;

class AccountCard extends StatefulWidget {
  const AccountCard({super.key, required this.data});
  final AccountsModel data;
  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  double coverwidth = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(
                    widget.data.fullname!,
                    textDirection: TextDirection.rtl,
                  ),
                  content: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.username!),
                        Text(widget.data.admin!),
                        Text(widget.data.ip ?? ""),
                        Text(
                          "حالة الحساب ${widget.data.loginstatus == true ? "on" : "off"}",
                          textDirection: TextDirection.rtl,
                        ),
                        Row(
                          children: [
                            Text("آخر تسجيل دخول"),
                            Text(
                              " ${widget.data.lastlogin != null ? df.DateFormat("yyyy-MM-dd HH:mm").format(widget.data.lastlogin!) : ""}",
                              textDirection: TextDirection.ltr,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, AccountsEdit.routename,
                              arguments: widget.data);
                        },
                        child: Text("تعديل")),
                    TextButton(
                        onPressed: () async {
                          await requestdelete(
                              endpoint: "accounts/delete",
                              body: {"id": widget.data.id.toString()});
                          context
                              .read<HelpsListProvider>()
                              .delete(id: widget.data.id);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "حذف",
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () async {
                          requestpost(
                              endpoint: "accounts/logoutaccount",
                              body: {
                                "id": userinfosharedpref
                                    .getStringList("userinfo")![0]
                              });
                          if (userinfosharedpref!
                                  .getStringList("userinfo")![0] ==
                              widget.data.id.toString()) {
                            userinfosharedpref.remove("userinfo");
                            Navigator.pushNamed(context, '/');
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "تسجيل الخروج",
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
                  title: Text(widget.data.fullname!),
                  subtitle: Text(widget.data.username!)),
            ),
          ),
        ),
      ),
    );
  }
}
