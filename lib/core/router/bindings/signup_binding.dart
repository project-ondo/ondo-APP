import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ondo/core/env.dart';
import 'package:ondo/data/datasource/auth/auth_remote_datasource.dart';
import 'package:ondo/data/repositories/auth/auth_repository_impl.dart';
import 'package:ondo/domain/repositories/auth/auth_repository.dart';
import 'package:ondo/domain/usecases/auth/send_email_code_usecase.dart';
import 'package:ondo/domain/usecases/auth/signup_usecase.dart';
import 'package:ondo/domain/usecases/auth/verify_email_code_usecase.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_email_code_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_email_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_introduction_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_major_interest_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_nickname_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_password_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_profile_image_setup_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_terms_agreement_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupFlowController>(
      () => SignupFlowController(),
    );

    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(Env.apiBaseUrl),
    );

    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
    );

    Get.lazyPut<SendEmailCodeUsecase>(
      () => SendEmailCodeUsecase(Get.find()),
    );

    Get.lazyPut<VerifyEmailCodeUsecase>(
      () => VerifyEmailCodeUsecase(Get.find()),
    );

    Get.lazyPut<SignupUsecase>(
      () => SignupUsecase(Get.find()),
    );

    Get.lazyPut<SignupTermsAgreementController>(
      () => SignupTermsAgreementController(),
    );

    Get.lazyPut<SignupEmailInputController>(
      () => SignupEmailInputController(Get.find()),
    );

    Get.lazyPut<SignupEmailCodeInputController>(
      () => SignupEmailCodeInputController(),
    );

    Get.lazyPut<SignupPasswordInputController>(
      () => SignupPasswordInputController(),
    );

    Get.lazyPut<SignupNicknameInputController>(
      () => SignupNicknameInputController(),
    );

    Get.lazyPut<SignupProfileImageSetupController>(
      () => SignupProfileImageSetupController(),
    );

    Get.lazyPut<SignupIntroductionInputController>(
      () => SignupIntroductionInputController(),
    );

    Get.lazyPut<SignupMajorInterestController>(
      () => SignupMajorInterestController(),
    );
  }
}
