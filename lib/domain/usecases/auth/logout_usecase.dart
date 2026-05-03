import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;
  final AuthLocalDatasource localDatasource;

  LogoutUseCase({
    required this.repository,
    required this.localDatasource,
  });

  Future<void> call() async {
    final refreshToken = await localDatasource.getRefreshToken();

    if (refreshToken != null && refreshToken.isNotEmpty) {
      // refreshToken 있으면 서버 로그아웃 + 로컬 삭제 (repository에서 처리)
      await repository.logout(refreshToken);
    } else {
      // refreshToken 없으면 로컬만 삭제
      await localDatasource.deleteAll();
    }
  }
}