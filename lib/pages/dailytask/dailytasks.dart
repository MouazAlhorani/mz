import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/dailytasksProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/dailytask_model.dart';
import 'package:mz_tak_app/models/help_model.dart';
import 'package:mz_tak_app/pages/dailytask/dailytasks_edit.dart';
import 'package:mz_tak_app/widgets/dailytasks_card.dart';
import 'package:provider/provider.dart';

class DailyTasks extends StatelessWidget {
  DailyTasks({super.key});
  static const String routename = "/homepage/dailytasks";
  List<HelpModel> helps = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(() async {
        var helpdata = await requestpost(endpoint: "helps/getdata");
        if (helpdata != null) {
          helps.clear();
          for (var i in helpdata) {
            helps.add(HelpModel.fromdata(data: i));
          }
        }
        return await requestpost(endpoint: 'dailytasks/getdata');
      }),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (!snaps.hasData) {
          return Scaffold(
            body: Center(child: Text("حصل خطأ ما")),
          );
        } else {
          List<DailyTaskModel> mydata = [];
          for (var i in snaps.data) {
            mydata.add(DailyTaskModel.fromdata(data: i, helps: helps));
          }
          context.read<DailyTasksListProvider>().list = mydata;
          return Dtpage(
            helps: helps,
          );
        }
      },
    );
  }
}

class Dtpage extends StatefulWidget {
  Dtpage({super.key, this.helps});
  final List<HelpModel>? helps;
  @override
  State<Dtpage> createState() => _RpageState();
}

class _RpageState extends State<Dtpage> {
  double radius = 0;
  @override
  Widget build(BuildContext context) {
    List<DailyTaskModel>? localdata =
        context.watch<DailyTasksListProvider>().list;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("المهام اليومية"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            Navigator.pushNamed(context, DailyTasksEdit.routename,
                arguments: {"helps": widget.helps});
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
                        if (i.task.toLowerCase().contains(x.toLowerCase())) {
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
                          .map((e) => DailyTasksCard(
                                helps: widget.helps,
                                data: e,
                                task: e.task,
                                taskhelp: e.taskhelp,
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
