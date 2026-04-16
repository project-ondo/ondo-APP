import '../../repositories/auth/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase({required this.repository});

  Future<bool> call({required String loginId, required String password}) async {
    return await repository.signIn(loginId, password);
  }
}
