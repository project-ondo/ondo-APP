import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call(String refreshToken) {
    return repository.logout(refreshToken);
  }
}