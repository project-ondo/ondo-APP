import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class SendEmailCodeUsecase {
  final AuthRepository repository;

  SendEmailCodeUsecase(this.repository);

  Future<void> call(String email) {
    return repository.sendEmailCode(email);
  }
}