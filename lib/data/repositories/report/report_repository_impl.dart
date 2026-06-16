import 'package:ondo/core/constants/report_type.dart';
import 'package:ondo/data/datasource/report/report_remote_datasource.dart';
import 'package:ondo/data/models/report/request/report_request_model.dart';
import 'package:ondo/domain/repositories/report/report_repository.dart';

class ReportRepositoryImpl extends ReportRepository {
  final ReportRemoteDatasource _remoteDatasource;

  ReportRepositoryImpl(this._remoteDatasource);

  @override
  Future<bool> report(
    ReportType targetType,
    String targetId,
    String description,
  ) async {
    final model = ReportRequestModel(
      targetType: targetType,
      targetId: targetId,
      description: description,
    );
    return await _remoteDatasource.report(model);
  }
}
