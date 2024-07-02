import 'package:flutter/material.dart';

class PBXmaininfoCard extends StatelessWidget {
  const PBXmaininfoCard(
      {super.key,
      required this.label,
      required this.value,
      this.color = Colors.white});
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 150,
          child: Container(
            decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 3, color: color))),
            child: Column(
              children: [Text(label), Divider(), Text(value)],
            ),
          ),
        ),
      ),
    );
  }
}
