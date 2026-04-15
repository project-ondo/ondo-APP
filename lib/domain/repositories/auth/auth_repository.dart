import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';

abstract class AuthRepository {
  Future<void> sendEmailCode(String email);

  Future<String> verifyEmailCode(String email, String code);

  Future<SignupResponseModel> signup(SignupRequestModel model);

  Future<bool> signIn(String loginId, String password);
}
