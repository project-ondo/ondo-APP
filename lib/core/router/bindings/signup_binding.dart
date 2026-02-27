import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ondo/presentation/auth/signup/controllers/email_code_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/email_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/introduction_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/major_interest_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/nickname_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/password_input_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/profile_image_setup_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/signup_flow_controller.dart';
import 'package:ondo/presentation/auth/signup/controllers/terms_agreement_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupFlowController>(() => SignupFlowController());

    Get.lazyPut<TermsAgreementController>(() => TermsAgreementController());
    Get.lazyPut<EmailInputController>(() => EmailInputController());
    Get.lazyPut<EmailCodeInputController>(() => EmailCodeInputController());
    Get.lazyPut<PasswordInputController>(() => PasswordInputController());
    Get.lazyPut<NicknameInputController>(() => NicknameInputController());
    Get.lazyPut<ProfileImageSetupController>(() => ProfileImageSetupController());
    Get.lazyPut<IntroductionInputController>(() => IntroductionInputController());
    Get.lazyPut<MajorInterestController>(() => MajorInterestController());
  }
}