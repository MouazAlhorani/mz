import 'package:flutter/material.dart';
import 'package:mz_tak_app/models/reminder_model.dart';

class RemindsListProvider extends ChangeNotifier {
  List<ReminderModel> _list = [];
  set list(data) {
    _list = data;
  }

  updatelist({id, newdata}) {
    _list[_list.indexWhere((element) => element.id == id)] = newdata;
    notifyListeners();
  }

  delete({id}) {
    _list.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  additem({newdata}) {
    _list.add(newdata);
    notifyListeners();
  }

  List<ReminderModel> get list => _list;
}
