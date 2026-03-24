import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<void> sendEmailCode(String email) {
    return datasource.sendEmailCode(email);
  }

  @override
  Future<String> verifyEmailCode(String email, String code) {
    return datasource.verifyEmailCode(email, code);
  }

  @override
  Future<SignupResponseModel> signup(SignupRequestModel model) {
    return datasource.signup(model);
  }
}