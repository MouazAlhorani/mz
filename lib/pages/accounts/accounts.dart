import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/accountsitemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';
import 'package:mz_tak_app/models/account_model.dart';
import 'package:mz_tak_app/pages/accounts/accounts_edit.dart';
import 'package:mz_tak_app/widgets/account_card.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';
import 'package:provider/provider.dart';

class Accounts extends StatelessWidget {
  Accounts({super.key});
  static const String routename = "/homepage/accounts";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestpost(endpoint: 'accounts/getdata'),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (!snaps.hasData) {
          return Scaffold(
            body: Center(child: Text("حصل خطأ ما")),
          );
        } else {
          List<AccountsModel> mydata = [];
          for (var i in snaps.data) {
            mydata.add(AccountsModel.fromdata(data: i));
          }
          context.read<AccountsListProvider>().list = mydata;
          return Apage();
        }
      },
    );
  }
}

class Apage extends StatefulWidget {
  Apage({super.key});

  @override
  State<Apage> createState() => _ApageState();
}

class _ApageState extends State<Apage> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    List<AccountsModel>? localdata = context.watch<AccountsListProvider>().list;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: AppBarBackGround(),
          title: Text("الحسابات"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pushNamed(context, AccountsEdit.routename);
          },
          child: MouseRegion(
            onHover: (x) => setState(() {
              radius = 25;
            }),
            onExit: (x) => setState(() {
              radius = 0;
            }),
            child: Stack(
              children: [
                CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(Icons.add)),
                CircleAvatar(
                  backgroundColor: Colors.amber.withOpacity(0.7),
                  radius: radius,
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(label: Text("بحث")),
                  onChanged: (x) {
                    for (var i in localdata) {
                      if (x.isEmpty) {
                        setState(() {
                          i.search = true;
                        });
                      } else {
                        if (i.username
                                .toString()
                                .toLowerCase()
                                .contains(x.toLowerCase()) ||
                            i.fullname
                                .toString()
                                .toLowerCase()
                                .contains(x.toLowerCase())) {
                          setState(() {
                            i.search = true;
                          });
                        } else {
                          setState(() {
                            i.search = false;
                          });
                        }
                      }
                    }
                  },
                ),
              ),
            ),
            TextButton.icon(
                onPressed: () async {
                  requestpost(endpoint: "accounts/logoutallaccounts", body: {
                    "id": userinfosharedpref.getStringList("userinfo")![0]
                  });
                  for (var i in localdata) {
                    if (i.id.toString() !=
                        userinfosharedpref.getStringList("userinfo")![0]) {
                      for (var j in localdata) {
                        j.loginstatus = false;
                        context
                            .read<AccountsListProvider>()
                            .updatelist(id: j.id, newdata: j);
                      }
                    }
                  }
                },
                icon: Icon(Icons.all_out),
                label: Text("تسجيل خروج جميع الحسابات")),
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...localdata.where((element) => element.search).map((e) {
                        return AccountCard(data: e);
                      }),
                    ],
                  ),
                ),
              ),
            ),
            DownlogoMz()
          ],
        ),
      ),
    );
  }
}
