import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_tak_app/controllers/pbx_requestpost.dart';
import 'package:mz_tak_app/models/pbx/callinwaiting_model.dart';
import 'package:mz_tak_app/models/pbx/extension_model.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';
import 'package:mz_tak_app/widgets/pbx_extinfo_card.dart';
import 'package:mz_tak_app/widgets/pbx_maininfo_card.dart';
import 'package:mz_tak_app/widgets/pbx_realtime_card.dart';

class RealTimePBX extends StatelessWidget {
  static String routename = "homepage/pbx/realtime";
  const RealTimePBX({super.key});

  @override
  Widget build(BuildContext context) {
    Map? args = ModalRoute.of(context)!.settings.arguments as Map?;
    List<Extension> extensionlist = [];
    List<CallsInWaitting>? waitingcalllist = [];
    List<Extension>? realtimecalls = [];
    return StreamBuilder(
        stream: Stream.periodic(Duration(seconds: 3), (x) => x),
        builder: (context, s) {
          Future(() async {
            if (args != null) {
              //ext list
              var ex = await pbxRequestpost(
                  endpoint: "extension/query",
                  resultkey: "result",
                  body: {
                    "param_token": args['token'],
                    "body_number": args['queue'].agents
                  });

              //waiting calls
              var wc = await pbxRequestpost(
                endpoint: "call/query",
                resultkey: "result",
                body: {
                  "param_token": args['token'],
                  "body_type": "inbound",
                },
              );

              //real time calls
              var rc = await pbxRequestpost(
                endpoint: "extension/query_call",
                resultkey: "result",
                body: {
                  "param_token": args['token'],
                  "body_number": args['queue'].agents
                },
              );

              //---
              extensionlist.clear();
              if (ex != null && ex.runtimeType != String) {
                for (var i in ex) {
                  extensionlist.add(Extension.getExtsListfromdata(data: i));
                }
              }
              waitingcalllist.clear();
              if (wc != null) {
                for (var i in wc) {
                  waitingcalllist.add(CallsInWaitting.fromdata(data: i));
                }
              }
              realtimecalls.clear();
              if (rc != null && rc.runtimeType != String) {
                for (var i in rc) {
                  realtimecalls.add(Extension.fromdataAsCallqueue(
                      exts: extensionlist, data: i));
                }
              }
            }
          });
          if (s.data == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  flexibleSpace: AppBarBackGround(),
                  centerTitle: true,
                  title: Text("الرصد في الزمن الحقيقي"),
                ),
                body: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          PBXmaininfoCard(
                              label: "Queue", value: args!['queue'].number),
                          PBXmaininfoCard(
                              label: "عدد التحويلات",
                              value: extensionlist.length.toString()),
                          PBXmaininfoCard(
                            label: "التحويلات المتاحة",
                            value: extensionlist
                                .where(
                                    (element) => element.status == "Registered")
                                .length
                                .toString(),
                            color: Colors.green,
                          ),
                          PBXmaininfoCard(
                            label: "المكالمات الجارية",
                            value: extensionlist
                                .where((element) => element.status == "Busy")
                                .length
                                .toString(),
                            color: Colors.red,
                          ),
                          PBXmaininfoCard(
                            label: "المكالمات على الانتظار",
                            value: waitingcalllist
                                .where((element) =>
                                    element.type == "inbound" &&
                                    element.memebers.length == 1)
                                .length
                                .toString(),
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text("المكالمات الواردة"),
                                  Divider(),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...waitingcalllist
                                            .where((element) =>
                                                element.type == "inbound" &&
                                                element.memebers.length == 1)
                                            .map((e) => RealTimeCard(
                                                  color: Colors.amberAccent,
                                                  caller: e.from,
                                                  trunkname: e.trunkname!,
                                                )),
                                        ...realtimecalls
                                            .where((element) =>
                                                element.type == "inbound")
                                            .map((e) => RealTimeCard(
                                                  color: Colors.redAccent,
                                                  caller: e.from!,
                                                  agent: e.name,
                                                  trunkname: e.trunkname!,
                                                ))
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                          VerticalDivider(),
                          Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Text("المكالمات الصادرة"),
                                  Divider(),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        ...realtimecalls
                                            .where((element) =>
                                                element.type != "inbound")
                                            .map((e) => RealTimeCard(
                                                  color: Colors.redAccent,
                                                  caller: e.to!,
                                                  agent: e.name,
                                                  trunkname: e.trunkname!,
                                                ))
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                          VerticalDivider(),
                          Expanded(
                              child: Column(
                            children: [
                              Text("حالة التحويلات"),
                              Divider(),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...extensionlist
                                          .where((element) =>
                                              element.status == "Busy")
                                          .map((e) => PBXExtInfo(
                                                label: e.name.toString(),
                                                color: Colors.red,
                                              )),
                                      ...extensionlist
                                          .where((element) =>
                                              element.status == "Registered")
                                          .map((e) => PBXExtInfo(
                                                label: e.name.toString(),
                                                color: Colors.green,
                                              )),
                                      ...extensionlist
                                          .where((element) =>
                                              element.status != "Busy" &&
                                              element.status != "Registered")
                                          .map((e) => PBXExtInfo(
                                              label: e.name.toString()))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                    DownlogoMz()
                  ],
                ),
              ),
            );
          }
        });
  }
}
