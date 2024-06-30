import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/pages/help/helps_edit.dart';
import 'package:mz_tak_app/widgets/help_card.dart';
import 'package:provider/provider.dart';

class Helps extends StatelessWidget {
  Helps({super.key});
  static const String routename = "/homepage/helps";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestpost(endpoint: 'helps/getdata'),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (!snaps.hasData) {
          return Scaffold(
            body: Center(child: Text("حصل خطأ ما")),
          );
        } else {
          List<HelpModel> mydata = [];
          for (var i in snaps.data) {
            mydata.add(HelpModel.fromdata(data: i));
          }
          context.read<HelpsListProvider>().list = mydata;
          return Hpage();
        }
      },
    );
  }
}

class Hpage extends StatefulWidget {
  Hpage({super.key});

  @override
  State<Hpage> createState() => _HpageState();
}

class _HpageState extends State<Hpage> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    List<HelpModel>? localdata = context.watch<HelpsListProvider>().list;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("المساعد"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pushNamed(context, HelpsEdit.routename);
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
                        if (i.helpname
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
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...localdata
                          .where((element) => element.search)
                          .map((e) => HelpCard(
                                data: e,
                                helpname: e.helpname,
                                helpdesc: e.helpdesc,
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
