import 'package:flutter/material.dart';

class TextFieldModel {
  final TextEditingController controller;
  final String label;
  IconData? suffixIcon;
  Function()? suffixFunction;
  Function(String? x)? validate;
  bool obscuretext;
  final int lines;
  final TextInputType inputtype;
  final TextDirection direction;
  bool visible;

  TextFieldModel(
      {required this.controller,
      required this.label,
      this.suffixFunction,
      this.suffixIcon,
      this.validate,
      this.obscuretext = false,
      this.lines = 1,
      this.inputtype = TextInputType.text,
      this.direction = TextDirection.rtl,
      this.visible = true});
}
