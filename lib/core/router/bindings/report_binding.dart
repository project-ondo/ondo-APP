import 'package:get/get.dart';
import 'package:ondo/data/datasource/report/report_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/report/report_repository_impl.dart';
import 'package:ondo/domain/repositories/report/report_repository.dart';
import 'package:ondo/domain/usecases/report/report_use_case.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ReportRemoteDatasource(Get.find<AuthClient>()),
    );

    Get.lazyPut<ReportRepository>(
      () => ReportRepositoryImpl(Get.find<ReportRemoteDatasource>()),
    );

    Get.lazyPut(
      () => ReportUseCase(Get.find<ReportRepository>()),
    );
  }
}
