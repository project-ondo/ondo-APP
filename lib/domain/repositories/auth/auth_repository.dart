abstract class AuthRepository {
  Future<void> sendEmailCode(String email);
}