import 'package:flutter/material.dart';

class MainItem {
  final String label;
  final IconData icon;
  final String url;
  bool visible;
  MainItem(
      {required this.label,
      required this.icon,
      required this.url,
      this.visible = true});
}
