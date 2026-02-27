import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/design_system/app_icon.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/ui/base/base_scaffold.dart';
import 'package:ondo/presentation/login/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    once(
      controller.isReady,
      (callback) {
        if (callback && context.mounted) {
          context.go(
            controller.isLogin.value ? RoutePaths.navigation : RoutePaths.login,
          );
        }
      },
    );

    return BaseScaffold(
      body: Center(
        child: FadeTransition(
          opacity: controller.opacity,
          child: Image.asset(AppIcon.logo.path),
        ),
      ),
    );
  }
}
