import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mz_tak_app/controllers/requestpost.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';
import 'package:mz_tak_app/models/mainitem_model.dart';
import 'package:mz_tak_app/pages/accounts/accounts.dart';
import 'package:mz_tak_app/pages/dailytask/dailytasks.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports.dart';
import 'package:mz_tak_app/pages/help/helps.dart';
import 'package:mz_tak_app/pages/pbx/pbx_homepage.dart';
import 'package:mz_tak_app/pages/reminder/reminds.dart';
import 'package:mz_tak_app/widgets/appBarbackground.dart';
import 'package:mz_tak_app/widgets/background.dart';
import 'package:mz_tak_app/widgets/downlogo.dart';
import 'package:mz_tak_app/widgets/mainitem_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routename = "homepage";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MainItem> mainitems = [
    MainItem(
      label: "الحسابات",
      icon: Icons.stacked_line_chart,
      url: Accounts.routename,
    ),
    MainItem(
      label: "تقارير المقسم",
      icon: Icons.stacked_line_chart,
      url: PBXHomePage.routename,
    ),
    MainItem(
      label: "التذكير",
      icon: Icons.schedule,
      url: Reminds.routename,
    ),
    MainItem(
      label: "المهام اليومية",
      icon: Icons.schedule,
      url: DailyTasks.routename,
    ),
    MainItem(
      label: "التقارير اليومية",
      icon: Icons.task,
      url: DailyTasksReports.routename,
    ),
    MainItem(
        label: "المساعدة",
        icon: Icons.help_center_outlined,
        url: Helps.routename),
  ];
  bool logouthover = false;
  @override
  Widget build(BuildContext context) {
    mainitems[0].visible = userinfosharedpref.getStringList("userinfo") != null
        ? userinfosharedpref.getStringList("userinfo")![4] == "superadmin"
        : false;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Mz App",
              style: GoogleFonts.sacramento(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            flexibleSpace: AppBarBackGround(),
            elevation: 50,
            actions: [
              Row(
                children: [
                  Visibility(
                      visible: logouthover,
                      child: Text(
                          userinfosharedpref.getStringList("userinfo") != null
                              ? userinfosharedpref.getStringList("userinfo")![3]
                              : "")),
                  MouseRegion(
                    onHover: (event) => setState(() {
                      logouthover = true;
                    }),
                    onExit: (event) => setState(() {
                      logouthover = false;
                    }),
                    child: IconButton(
                        onPressed: () async {
                          await requestpost(endpoint: "auth/logout", body: {
                            "id":
                                userinfosharedpref.getStringList("userinfo")![0]
                          });
                          userinfosharedpref.remove("userinfo");

                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        icon: Icon(
                          Icons.logout,
                        )),
                  ),
                ],
              )
            ],
          ),
          body: Stack(
            children: [
              BackGround(),
              Column(
                children: [
                  Expanded(
                    child: Center(
                        child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ...mainitems
                                    .where((element) =>
                                        element.visible &&
                                        mainitems.indexOf(element).isEven)
                                    .map((e) => MainItemCard(
                                          label: e.label,
                                          icon: e.icon,
                                          gotopage: e.url,
                                        ))
                              ],
                            ),
                            Row(
                              children: [
                                ...mainitems
                                    .where((element) =>
                                        element.visible &&
                                        mainitems.indexOf(element).isOdd)
                                    .map((e) => MainItemCard(
                                          label: e.label,
                                          icon: e.icon,
                                          gotopage: e.url,
                                        ))
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                  ),
                  DownlogoMz()
                ],
              ),
            ],
          )),
    );
  }
}
