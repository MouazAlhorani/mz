import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mz_tak_app/constant.dart';
import 'package:mz_tak_app/controllers/pbx_requestpost.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/pbx/queue_model.dart';
import 'package:mz_tak_app/pages/pbx/realtime.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';

class PBXHomePage extends StatelessWidget {
  static String routename = "homepage/pbxhomepage";
  const PBXHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<MQueue>? queue = [];
    return FutureBuilder(future: Future(() async {
      var token =
          await pbxRequestpost(endpoint: "gettoken", resultkey: "result");
      if (token != null) {
        var q = await pbxRequestpost(
            endpoint: "queues", resultkey: "result", body: {"token": token});
        if (q != null) {
          queue.add(MQueue(queuename: "all", number: "all", agents: "all"));
          for (var i in q) {
            queue.add(MQueue.fromdata(data: i));
          }
        }
      }
      return token;
    }), builder: (_, s) {
      if (s.connectionState == ConnectionState.waiting) {
        return Scaffold(
          body: CircularProgressIndicator(),
        );
      } else if (!s.hasData) {
        return Scaffold(
          body: Text("خطأ في المصداقة"),
        );
      } else {
        return HPBX(token: s.data, queue: queue, selectedqueue: queue.first);
      }
    });
  }
}

class HPBX extends StatefulWidget {
  final List<MQueue> queue;
  final String token;
  MQueue selectedqueue;
  HPBX(
      {super.key,
      required this.token,
      required this.queue,
      required this.selectedqueue});

  @override
  State<HPBX> createState() => _HPBXState();
}

class _HPBXState extends State<HPBX> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              flexibleSpace: AppBarBackGround(),
              centerTitle: true,
              title: Text("تقارير المقسم"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 600,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RealTimePBX.routename, arguments: {
                                  "token": widget.token,
                                  "queue": widget.selectedqueue
                                });
                              },
                              child: Card(
                                child: ListTile(
                                  mouseCursor: SystemMouseCursors.click,
                                  title: Text("الرصد في الزمن الحقيقي"),
                                  subtitle: Row(
                                    children: [
                                      Text("اختر المجال"),
                                      SizedBox(width: 50),
                                      DropdownButton(
                                          value: widget.selectedqueue,
                                          items: widget.queue
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.number)))
                                              .toList(),
                                          onChanged: (x) {
                                            setState(() {
                                              widget.selectedqueue = x!;
                                            });
                                          }),
                                    ],
                                  ),
                                  trailing: Icon(Icons.timer_3_rounded),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                DownlogoMz()
              ],
            )));
  }
}
