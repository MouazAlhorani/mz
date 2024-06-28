import 'package:flutter/material.dart';
import 'package:mz_tak_app/models/mainitem_model.dart';
import 'package:mz_tak_app/pages/reminder/reminds.dart';
import 'package:mz_tak_app/widgets/mainitem_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routename = "homepage";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MainItem> mainitems = [
    MainItem(label: "تقارير المقسم", icon: Icons.stacked_line_chart, url: '/'),
    MainItem(label: "التذكير", icon: Icons.schedule, url: Reminds.routename),
    MainItem(label: "التقارير اليومية", icon: Icons.task, url: '/'),
    MainItem(label: "المساعدة", icon: Icons.help_center_outlined, url: '/'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  icon: Icon(Icons.logout))
            ],
          ),
          body: Center(
              child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  Row(
                    children: [
                      ...mainitems
                          .where((element) => mainitems.indexOf(element).isEven)
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
                          .where((element) => mainitems.indexOf(element).isOdd)
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
          ))),
    );
  }
}
