import 'package:ondo/core/constants/report_type.dart';
import 'package:ondo/domain/repositories/report/report_repository.dart';

class ReportUseCase {
  final ReportRepository _repository;

  ReportUseCase(this._repository);

  Future<bool> call({
    required ReportType targetType,
    required String targetId,
    required String description,
  }) async {
    return await _repository.report(targetType, targetId, description);
  }
}
