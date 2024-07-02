import 'package:flutter/material.dart';

class TextFieldCard extends StatelessWidget {
  TextFieldCard(
      {super.key,
      required this.label,
      required this.controller,
      this.suffixIcon,
      this.suffixFunction,
      this.validate,
      this.obscuretext = false,
      this.inputType = TextInputType.text,
      this.maxlines = 1,
      this.direction = TextDirection.rtl,
      this.submitted});
  final String label;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final Function()? suffixFunction;
  final Function(String? x)? validate, submitted;
  final bool obscuretext;
  final TextDirection direction;
  TextInputType inputType;
  int? maxlines;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width < 500
          ? MediaQuery.of(context).size.width
          : 500,
      child: TextFormField(
        onFieldSubmitted: submitted,
        textDirection: direction,
        textAlign: TextAlign.center,
        controller: controller,
        validator: validate == null ? null : (x) => validate!(x),
        obscureText: obscuretext,
        keyboardType: inputType,
        maxLines: maxlines,
        decoration: InputDecoration(
            label: Text(label),
            suffix: suffixIcon == null
                ? null
                : IconButton(
                    onPressed: suffixFunction, icon: Icon(suffixIcon))),
      ),
    );
  }
}
