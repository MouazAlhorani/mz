import 'package:flutter/material.dart';
import 'package:mz_tak_app/models/dailytasksreport_model.dart';

class DailyTasksReportsListProvider extends ChangeNotifier {
  List<DailyTasksReportModel> _list = [];
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

  List<DailyTasksReportModel> get list {
    return _list;
  }
}
