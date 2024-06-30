import 'package:flutter/material.dart';

class HelpModel {
  HelpModel(
      {required this.id,
      required this.helpname,
      this.helpdesc,
      this.search = true});

  factory HelpModel.fromdata({data}) {
    return HelpModel(
        id: data['id'],
        helpname: data['helpname'],
        helpdesc: data['helpdesc'],
        search: true);
  }
  final int id;
  final String helpname;
  final String? helpdesc;
  bool search;
}
