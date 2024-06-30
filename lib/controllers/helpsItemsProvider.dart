import 'package:flutter/material.dart';
import 'package:mz_tak_app/models/help_model.dart';

class HelpsListProvider extends ChangeNotifier {
  List<HelpModel> _list = [];
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

  List<HelpModel> get list => _list;
}
