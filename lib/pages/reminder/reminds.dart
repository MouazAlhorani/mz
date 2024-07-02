import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_tak_app/controllers/remindsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/reminder_model.dart';
import 'package:mz_tak_app/pages/reminder/reminds_edit.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';
import 'package:mz_tak_app/widgets/reminder_card.dart';
import 'package:provider/provider.dart';

class Reminds extends StatelessWidget {
  Reminds({super.key});
  static const String routename = "/homepage/reminds";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestpost(endpoint: 'reminds/getdata'),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (!snaps.hasData) {
          return Scaffold(
            body: Center(child: Text("حصل خطأ ما")),
          );
        } else {
          List<ReminderModel> mydata = [];
          for (var i in snaps.data) {
            mydata.add(ReminderModel.fromdata(data: i));
          }
          context.read<RemindsListProvider>().list = mydata;
          return Rpage();
        }
      },
    );
  }
}

class Rpage extends StatefulWidget {
  Rpage({super.key});

  @override
  State<Rpage> createState() => _RpageState();
}

class _RpageState extends State<Rpage> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    List<ReminderModel>? localdata = context.watch<RemindsListProvider>().list;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: AppBarBackGround(),
          title: Text("التذكير"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pushNamed(context, RemindsEdit.routename);
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
                        if (i.name.toLowerCase().contains(x.toLowerCase())) {
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
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...localdata
                          .where((element) => element.alert && element.search)
                          .map((e) => ReminderCard(
                                data: e,
                                name: e.name,
                                expire: e.expire,
                                alert: e.alert,
                                timetoexpire: e.timetoexpire,
                              )),
                      ...localdata
                          .where((element) => !element.alert && element.search)
                          .map((e) => ReminderCard(
                                data: e,
                                name: e.name,
                                expire: e.expire,
                                alert: e.alert,
                                timetoexpire: e.timetoexpire,
                              ))
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
