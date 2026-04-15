import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/domain/usecases/auth/sign_in_use_case.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final SignInUseCase signInUseCase;

  LoginController({required this.signInUseCase});

  var emailError = RxnString();
  var passwordError = RxnString();
  var generalError = RxnString();
  var showPassword = false.obs;

  bool validate() {
    emailError.value = null;
    passwordError.value = null;
    generalError.value = null;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      emailError.value = AppStrings.inputEmailAndPassword;
      passwordError.value = AppStrings.inputEmailAndPassword;
      return false;
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      emailError.value = AppStrings.emailRegex;
      return false;
    }

    if (password.length < 8 || password.length > 15) {
      passwordError.value = AppStrings.passwordLength;
      return false;
    }

    final passwordRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!passwordRegex.hasMatch(password)) {
      passwordError.value = AppStrings.passwordRegex;
      return false;
    }

    return true;
  }

  Future<bool> login() async {
    if (!validate()) return false;

    final result = await signInUseCase.call(
      loginId: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (result) {
      generalError.value = null;
    } else {
      generalError.value = AppStrings.inputEmailOrPassword;
    }
    return result;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
