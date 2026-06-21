import 'package:ondo/core/constants/report_type.dart';

class ReportRequestModel {
  final ReportType targetType;
  final String targetId;
  final String description;

  ReportRequestModel({
    required this.targetType,
    required this.targetId,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'targetType': targetType.value,
    'targetId': targetId,
    'description': description,
  };
}
