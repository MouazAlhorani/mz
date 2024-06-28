import 'package:flutter/material.dart';
import 'package:mz_tak_app/models/reminder_model.dart';

class RemindsListProvider extends ChangeNotifier {
  List<ReminderModel> _list = [];
  set list(data) {
    _list = data;
  }

  updatelist({id, newdata}) {
    _list[_list.indexWhere((element) => element.id == id)] = newdata;
  }

  additem({newdata}) {
    _list.add(newdata);
  }

  List<ReminderModel> get list => _list;
}

class testProvider extends ChangeNotifier {
  int _count = 0;

  set count(int newdata) {
    _count += newdata;
  }

  int get count => _count;
}
