import 'package:flutter/material.dart';

class PBXExtInfo extends StatelessWidget {
  const PBXExtInfo({super.key, required this.label, this.color = Colors.grey});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 3, color: color))),
          child: ListTile(
            title: Text(
              label,
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  }
}
