import 'package:mz_tak_app/models/help_model.dart';

class DailyTaskModel {
  DailyTaskModel(
      {required this.id,
      required this.task,
      this.taskhelp,
      this.search = true});

  factory DailyTaskModel.fromdata({data, required List<HelpModel>? helps}) {
    return DailyTaskModel(
        id: data['id'],
        task: data['task'],
        taskhelp: data['taskhelp'] == null
            ? null
            : helps![
                helps.indexWhere((element) => element.id == data['taskhelp'])],
        search: true);
  }
  final int id;
  final String task;
  final HelpModel? taskhelp;
  bool search;
}
