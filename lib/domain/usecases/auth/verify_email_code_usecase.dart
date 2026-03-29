import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class VerifyEmailCodeUsecase {
  final AuthRepository repository;

  VerifyEmailCodeUsecase(this.repository);

  Future<String> call(String email, String code){
    return repository.verifyEmailCode(email, code);
  }
}