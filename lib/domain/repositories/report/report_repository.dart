import 'package:ondo/core/constants/report_type.dart';

abstract class ReportRepository {
  Future<bool> report(
    ReportType targetType,
    String targetId,
    String description,
  );
}
