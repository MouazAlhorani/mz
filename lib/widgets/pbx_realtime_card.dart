import 'package:flutter/material.dart';

class RealTimeCard extends StatelessWidget {
  RealTimeCard(
      {super.key,
      required this.color,
      required this.caller,
      this.agent,
      required this.trunkname});
  final Color color;
  String? agent;
  String caller;
  String trunkname;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: color, width: 3))),
          child: ListTile(
            title: Text(
              agent ?? "",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Row(
              children: [
                Text(
                  caller,
                  style: TextStyle(fontSize: 15),
                ),
                Spacer(),
                Text("over $trunkname")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
