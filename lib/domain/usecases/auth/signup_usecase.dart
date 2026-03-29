import 'package:ondo/data/models/auth/request/signup_request_model.dart';
import 'package:ondo/data/models/auth/response/signup_response_model.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;

  SignupUsecase(this.repository);

  Future<SignupResponseModel> call(SignupRequestModel model){
    return repository.signup(model);
  }
}