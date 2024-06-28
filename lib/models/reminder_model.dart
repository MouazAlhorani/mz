import 'package:flutter/material.dart';

class ReminderModel {
  ReminderModel(
      {required this.id,
      required this.name,
      this.desc,
      this.url,
      this.type,
      this.expire,
      required this.remindbefor,
      this.timetoexpire,
      this.alert = false,
      this.notifi = true});

  factory ReminderModel.fromdata({data}) {
    return ReminderModel(
        id: data['id'],
        name: data['remindname'],
        desc: data['reminddesc'],
        type: data['remindtype'],
        url: data['url'],
        expire: data['expiredate'] == null
            ? null
            : DateTime.parse(data['expiredate']),
        remindbefor: data['remindbefor'],
        timetoexpire: data['remainingdays'],
        alert: data['alertstatus'],
        notifi: data['notification']);
  }

  final String? url, desc, type;
  final int id, remindbefor;
  final String? timetoexpire;
  final String name;
  final DateTime? expire;
  bool alert, notifi;
}
