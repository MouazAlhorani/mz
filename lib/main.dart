import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/accountsitemsProvider.dart';
import 'package:mz_tak_app/controllers/auth_function.dart';
import 'package:mz_tak_app/controllers/dailytasksProvider.dart';
import 'package:mz_tak_app/controllers/dailytasksreportsProvider.dart';
import 'package:mz_tak_app/controllers/helpsItemsProvider.dart';
import 'package:mz_tak_app/controllers/remindsItemsProvider.dart';
import 'package:mz_tak_app/controllers/shared_pref.dart';
import 'package:mz_tak_app/pages/accounts/accounts.dart';
import 'package:mz_tak_app/pages/accounts/accounts_edit.dart';
import 'package:mz_tak_app/pages/dailytask/dailytasks.dart';
import 'package:mz_tak_app/pages/dailytask/dailytasks_edit.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports.dart';
import 'package:mz_tak_app/pages/dailytasksreports/dailytasksreports_edit.dart';
import 'package:mz_tak_app/pages/help/helps.dart';
import 'package:mz_tak_app/pages/help/helps_edit.dart';
import 'package:mz_tak_app/pages/homepage.dart';
import 'package:mz_tak_app/pages/loginpage.dart';
import 'package:mz_tak_app/pages/pbx/pbx_homepage.dart';
import 'package:mz_tak_app/pages/pbx/realtime.dart';
import 'package:mz_tak_app/pages/reminder/reminds.dart';
import 'package:mz_tak_app/pages/reminder/reminds_edit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RemindsListProvider()),
      ChangeNotifierProvider(create: (_) => HelpsListProvider()),
      ChangeNotifierProvider(create: (_) => DailyTasksListProvider()),
      ChangeNotifierProvider(create: (_) => DailyTasksReportsListProvider()),
      ChangeNotifierProvider(create: (_) => AccountsListProvider()),
    ],
    child: MzApp(),
  ));
}

class MzApp extends StatelessWidget {
  MzApp({super.key});
  bool autologin = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future(
        () async {
          userinfosharedpref = await SharedPreferences.getInstance();
          List<String>? userinfo = userinfosharedpref.getStringList("userinfo");
          if (userinfo != null) {
            Map result = await authFunction(
                username: userinfo[1], password: userinfo[2]);

            if (result['result'] == "UNAUTHORIZED") {
              autologin = false;
              userinfosharedpref.remove("userinfo");
            } else if (result['result'] != "server_error") {
              autologin = true;
            }
          }
        },
      ),
      builder: (_, s) {
        return SafeArea(
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              '/': (context) => autologin ? HomePage() : LogInPage(),
              HomePage.routename: (context) => HomePage(),
              Reminds.routename: (context) => Reminds(),
              RemindsEdit.routename: (context) => RemindsEdit(),
              Helps.routename: (context) => Helps(),
              HelpsEdit.routename: (context) => HelpsEdit(),
              DailyTasks.routename: (context) => DailyTasks(),
              DailyTasksEdit.routename: (context) => DailyTasksEdit(),
              DailyTasksReports.routename: (context) => DailyTasksReports(),
              DailyTasksReportsEdit.routename: (context) =>
                  DailyTasksReportsEdit(),
              PBXHomePage.routename: (context) => PBXHomePage(),
              RealTimePBX.routename: (context) => RealTimePBX(),
              Accounts.routename: (context) => Accounts(),
              AccountsEdit.routename: (context) => AccountsEdit()
            },
          ),
        );
      },
    );
  }
}
