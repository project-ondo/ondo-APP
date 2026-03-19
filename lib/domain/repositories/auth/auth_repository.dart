abstract class AuthRepository {
  Future<void> sendEmailCode(String email);
  Future<String> verifyEmailCode(String email, String code);
}