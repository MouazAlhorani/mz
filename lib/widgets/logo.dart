import 'package:flutter/material.dart';

class MzLogo extends StatelessWidget {
  const MzLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Mz _>App",
            style: TextStyle(
              fontSize: 30,
              fontFamily: "IndieFlower",
            )),
        Text("by:   Mouaz al-Horani",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontFamily: "IndieFlower",
            ))
      ],
    );
  }
}
