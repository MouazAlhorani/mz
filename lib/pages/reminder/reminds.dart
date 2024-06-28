import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/remindsItemsProvider.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/models/reminder_model.dart';
import 'package:mz_tak_app/pages/reminder/reminds_edit.dart';
import 'package:mz_tak_app/widgets/reminder_card.dart';
import 'package:provider/provider.dart';

class Reminds extends StatelessWidget {
  Reminds({super.key});
  static const String routename = "/homepage/reminds";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: requestpost(endpoint: 'getreminds'),
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
  List<ReminderModel>? localdata;
  double radius = 0;
  int x = 0;
  @override
  Widget build(BuildContext context) {
    x = context.watch<testProvider>().count;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.watch<testProvider>().count.toString()),
                IconButton(
                    onPressed: () {
                      context.read<testProvider>().count = 5;
                    },
                    icon: Icon(Icons.add))
                // ...localdata
                //     .where((element) => element.alert)
                //     .map((e) => ReminderCard(
                //           data: e,
                //           name: e.name,
                //           expire: e.expire,
                //           alert: e.alert,
                //           timetoexpire: e.timetoexpire,
                //         )),
                // ...localdata
                //     .where((element) => !element.alert)
                //     .map((e) => ReminderCard(
                //           data: e,
                //           name: e.name,
                //           expire: e.expire,
                //           alert: e.alert,
                //           timetoexpire: e.timetoexpire,
                //         ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
