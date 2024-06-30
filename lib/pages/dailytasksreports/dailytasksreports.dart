import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/dailytasksreportsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports_edit.dart';
import 'package:mz_tak_app/widgets/dailytasksreport_card.dart';
import 'package:provider/provider.dart';

class DailyTasksReports extends StatelessWidget {
  DailyTasksReports({super.key});
  static const String routename = "/homepage/dailytasksreports";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestpost(endpoint: 'dailytasksreports/getdata'),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (!snaps.hasData) {
          return Scaffold(
            body: Center(child: Text("حصل خطأ ما")),
          );
        } else {
          List<DailyTasksReportModel> mydata = [];
          for (var i in snaps.data) {
            mydata.add(DailyTasksReportModel.fromdata(data: i));
          }
          context.read<DailyTasksReportsListProvider>().list = mydata;
          return DTrpage();
        }
      },
    );
  }
}

class DTrpage extends StatefulWidget {
  DTrpage({super.key});

  @override
  State<DTrpage> createState() => _DTrpageState();
}

class _DTrpageState extends State<DTrpage> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    List<DailyTasksReportModel>? localdata =
        context.watch<DailyTasksReportsListProvider>().list;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("التقارير اليومية"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pushNamed(context, DailyTasksReportsEdit.routename);
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
                        if (i.createby
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
                          .map((e) => DailyTasksReportCard(
                                data: e,
                                report: e.report,
                                createby: e.createby,
                                reportdate: e.reportdate,
                                createby_id: e.createby_id,
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
