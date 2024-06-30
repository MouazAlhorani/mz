import 'package:mz_tak_app/models/help_model.dart';

class DailyTasksReportModel {
  DailyTasksReportModel(
      {required this.id,
      required this.report,
      required this.createby,
      required this.reportdate,
      this.createby_id,
      this.search = true});

  factory DailyTasksReportModel.fromdata({data}) {
    return DailyTasksReportModel(
        id: data['id'],
        report: data['report'],
        reportdate: DateTime.parse(data['reportdate']),
        createby: data['createby'],
        createby_id: data['createby_id'],
        search: true);
  }
  final int id;
  final String report, createby;
  final DateTime reportdate;
  final int? createby_id;
  bool search;
}
