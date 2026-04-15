import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/models/auth/request/sign_in_request_model.dart';
import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/sign_in_response_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl({
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<void> sendEmailCode(String email) {
    return remoteDatasource.sendEmailCode(email);
  }

  @override
  Future<String> verifyEmailCode(String email, String code) {
    return remoteDatasource.verifyEmailCode(email, code);
  }

  @override
  Future<SignupResponseModel> signup(SignupRequestModel model) {
    return remoteDatasource.signup(model);
  }

  @override
  Future<void> signIn(SignInRequestModel model) async {
    final json = await remoteDatasource.signIn(model);
    if (json != null) {
      final res = SignInResponseModel.fromJson(json);
      await localDatasource.saveToken(
        accessToken: res.accessToken,
        accessTokenExpiration: res.accessTokenExpiration,
        refreshToken: res.refreshToken,
        refreshTokenExpiration: res.refreshTokenExpiration,
      );
    }
  }
}
