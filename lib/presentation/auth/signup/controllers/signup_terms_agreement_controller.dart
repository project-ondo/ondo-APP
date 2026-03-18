import 'package:get/get.dart';

class SignupTermsAgreementController extends GetxController{
  final RxBool isAgreementChecked = false.obs;

  bool get canProceed => isAgreementChecked.value;

  bool toggleAgreement(){
    return isAgreementChecked.value = !isAgreementChecked.value;
  }
}