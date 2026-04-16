import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/domain/usecases/auth/sign_in_use_case.dart';

class LoginController extends GetxController {
  final SignInUseCase signInUseCase;

  LoginController({required this.signInUseCase});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var emailError = RxnString();
  var passwordError = RxnString();
  var generalError = RxnString();
  var showPassword = false.obs;
  var isLoading = false.obs;

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

    if (password.length < 8 || password.length > 50) {
      passwordError.value = AppStrings.passwordLength;
      return false;
    }

    return true;
  }

  Future<bool> login() async {
    if (!validate()) return false;
    if (isLoading.value) return false;

    try {
      isLoading.value = true;

      // loginId = 이메일 @ 앞부분 (회원가입 시 동일하게 처리)
      final loginId = emailController.text.trim().split('@').first;

      final success = await signInUseCase(
        loginId: loginId,
        password: passwordController.text,
      );

      if (!success) {
        generalError.value = AppStrings.inputEmailOrPassword;
        return false;
      }

      generalError.value = null;
      return true;
    } catch (e) {
      generalError.value = AppStrings.inputEmailOrPassword;
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}