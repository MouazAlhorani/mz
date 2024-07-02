import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //   // Colors.teal.withOpacity(0.5),
              //   // Colors.deepPurple,
              //   // Colors.black.withOpacity(0.5),
              // ]
              // )
              ),
        ),
      ],
    );
  }
}
