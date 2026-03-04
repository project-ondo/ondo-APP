import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_strings.dart';
import 'package:ondo/core/router/app_router.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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

  void login() {
    final String testEmail = 'test1@gmail.com';
    final String testPassword = 'asdf1234!';

    if (!validate()) return;

    if (emailController.text == testEmail &&
        passwordController.text == testPassword) {
      generalError.value = null;
    } else {
      generalError.value = AppStrings.inputEmailOrPassword;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
