import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:go_router/go_router.dart';

import '../../../presentation/auth/password_reset/controllers/password_reset_flow_controller.dart';
import '../../../presentation/auth/password_reset/screens/password_reset_email_code_screen.dart';
import '../../../presentation/auth/password_reset/screens/password_reset_email_screen.dart';
import '../../../presentation/auth/password_reset/screens/password_reset_password_completed_screen.dart';
import '../../../presentation/auth/password_reset/screens/password_reset_password_screen.dart';
import '../app_router.dart';
import '../bindings/password_reset_binding.dart';

class PasswordResetRoutes {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) {
        PasswordResetBinding().dependencies();
        return child;
      },
      redirect: (context, state) {
        if (!Get.isRegistered<PasswordResetFlowController>()) {
          PasswordResetBinding().dependencies();
        }

        final flowController = Get.find<PasswordResetFlowController>();
        final location = state.uri.path;

        final allowedPaths = {
          RoutePaths.passwordResetInputEmail,
          RoutePaths.passwordResetInputEmailCode,
        };

        if (!flowController.isEmailVerified &&
            !allowedPaths.contains(location)) {
          return RoutePaths.passwordResetInputEmail;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.passwordResetInputEmail,
          name: 'passwordResetInputEmail',
          builder: (context, state) => const PasswordResetEmailInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetInputEmailCode,
          name: 'passwordResetInputEmailCode',
          builder: (context, state) =>
          const PasswordResetEmailCodeInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetInputPassword,
          name: 'passwordResetInputPassword',
          builder: (context, state) => const PasswordResetPasswordScreen(),
        ),
        GoRoute(
          path: RoutePaths.passwordResetComplete,
          name: 'passwordResetComplete',
          builder: (context, state) => const PasswordResetCompletedScreen(),
        ),
      ],
    ), // password_reset
  ];

}