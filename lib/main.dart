import 'package:flutter/material.dart';
import 'package:mz_tak_app/controllers/remindsItemsProvider.dart';
import 'package:mz_tak_app/pages/homepage.dart';
import 'package:mz_tak_app/pages/loginpage.dart';
import 'package:mz_tak_app/pages/reminder/reminds.dart';
import 'package:mz_tak_app/pages/reminder/reminds_edit.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RemindsListProvider()),
      ChangeNotifierProvider(create: (_) => testProvider()),
    ],
    child: MzApp(),
  ));
}

class MzApp extends StatelessWidget {
  const MzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LogInPage(),
          HomePage.routename: (context) => HomePage(),
          Reminds.routename: (context) => Reminds(),
          RemindsEdit.routename: (context) => RemindsEdit()
        },
      ),
    );
  }
}
