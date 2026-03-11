import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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
    Get.lazyPut<SignupFlowController>(() => SignupFlowController());

    Get.lazyPut<SignupTermsAgreementController>(() => SignupTermsAgreementController());
    Get.lazyPut<SignupEmailInputController>(() => SignupEmailInputController());
    Get.lazyPut<SignupEmailCodeInputController>(() => SignupEmailCodeInputController());
    Get.lazyPut<SignupPasswordInputController>(() => SignupPasswordInputController());
    Get.lazyPut<SignupNicknameInputController>(() => SignupNicknameInputController());
    Get.lazyPut<SignupProfileImageSetupController>(() => SignupProfileImageSetupController());
    Get.lazyPut<SignupIntroductionInputController>(() => SignupIntroductionInputController());
    Get.lazyPut<SignupMajorInterestController>(() => SignupMajorInterestController());
  }
}