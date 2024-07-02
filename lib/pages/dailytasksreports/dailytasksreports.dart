import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/dailytasksreportsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports_edit.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/dailytasksreport_card.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';
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
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    List<DailyTasksReportModel>? localdata =
        context.watch<DailyTasksReportsListProvider>().list;
    List<Map<int, List>> years = [];

    years.clear();

    for (var i in localdata) {
      if (!years.any(
          (element) => element.keys.toList().contains(i.reportdate.year))) {
        years.add({i.reportdate.year: []});
      }
    }
    for (var i in years) {
      for (var j in localdata) {
        if (!i[j.reportdate.year]!.contains(j.reportdate.month)) {
          i[j.reportdate.year]!.add(j.reportdate.month);
        }
      }
    }
    years.sort((a, b) => b.keys.first.compareTo(a.keys.first));
    for (var i in years) {
      i.values.toList().first.sort((a, b) => b.compareTo(a));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: AppBarBackGround(),
          title: Text("التقارير اليومية"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () async {
            List<DailyTaskModel> dailytasks = [];
            List<HelpModel> helps = [];

            Navigator.pushNamed(
              context,
              DailyTasksReportsEdit.routename,
            );
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
                const CircleAvatar(
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
                          searching = false;
                          i.search = true;
                        });
                      } else {
                        if (i.createby
                            .toLowerCase()
                            .contains(x.toLowerCase())) {
                          setState(() {
                            searching = true;
                            i.search = true;
                          });
                        } else {
                          setState(() {
                            searching = true;
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
                      for (var i in years)
                        i.keys
                            .toList()
                            .map((e) => SizedBox(
                                width: 600,
                                child: ExpansionTile(
                                  backgroundColor: Colors.grey.shade100,
                                  title: Text("عام ${e.toString()}"),
                                  subtitle: Text(
                                      "مجموع التقارير __ ${localdata.where((element) => element.reportdate.year == e).length} تقرير خلال ${i[e]!.length} ${i[e]!.length == 1 ? "شهر" : i[e]!.length == 2 ? "شهرين" : i[e]!.length < 10 ? "أشهر" : "شهراً"}"),
                                  children: [
                                    searching
                                        ? const Align(
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              "النتائج التالية تخص فقط الحساب الموجود في البحث",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    ...i[e]!.map((m) => ExpansionTile(
                                          title: Text(
                                              "شهر ${m.toString()} - ${e.toString()}"),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Colors.amber,
                                                height: 15,
                                                width: localdata
                                                        .where((element) =>
                                                            element.reportdate
                                                                    .year ==
                                                                e &&
                                                            element.reportdate
                                                                    .month ==
                                                                m)
                                                        .length *
                                                    100 /
                                                    localdata
                                                        .where((element) =>
                                                            element.reportdate
                                                                .year ==
                                                            e)
                                                        .length,
                                              ),
                                              Text(
                                                  "${localdata.where((element) => element.reportdate.year == e && element.reportdate.month == m && element.search).length} تقرير"),
                                            ],
                                          ),
                                          children: [
                                            ...localdata.reversed
                                                .where(
                                                    (element) => element.search)
                                                .where((element) =>
                                                    element.reportdate.year ==
                                                        e &&
                                                    element.reportdate.month ==
                                                        m)
                                                .map((r) =>
                                                    DailyTasksReportCard(
                                                        report: r.report,
                                                        reportdate:
                                                            r.reportdate,
                                                        createby: r.createby,
                                                        data: r))
                                          ],
                                        ))
                                  ],
                                )))
                            .first

                      // ...years.map((e) => null)
                      // ...localdata.reversed
                      //     .where((element) => element.search)
                      //     .map((e) => DailyTasksReportCard(
                      //           data: e,
                      //           report: e.report,
                      //           createby: e.createby,
                      //           reportdate: e.reportdate,
                      //           createby_id: e.createby_id,
                      //         )),
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
