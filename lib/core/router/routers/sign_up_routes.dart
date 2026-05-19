import 'package:go_router/go_router.dart';

import '../../../presentation/auth/signup/screens/signup_complete_screen.dart';
import '../../../presentation/auth/signup/screens/signup_email_code_input_screen.dart';
import '../../../presentation/auth/signup/screens/signup_email_input_screen.dart';
import '../../../presentation/auth/signup/screens/signup_introduction_input_screen.dart';
import '../../../presentation/auth/signup/screens/signup_major_interest_setup_screen.dart';
import '../../../presentation/auth/signup/screens/signup_nickname_setup_screen.dart';
import '../../../presentation/auth/signup/screens/signup_password_setup_screen.dart';
import '../../../presentation/auth/signup/screens/signup_profile_image_setup_screen.dart';
import '../../../presentation/auth/signup/screens/signup_terms_agreement_screen.dart';
import '../app_router.dart';
import '../bindings/signup_binding.dart';

class SignupRoutes {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) {
        SignupBinding().dependencies();
        return child;
      },
      redirect: (context, state) {
        if (state.uri.toString() == RoutePaths.signup) {
          return RoutePaths.signupTerms;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: RoutePaths.signupTerms,
          name: 'signupTerms',
          builder: (context, state) => const SignupTermsAgreementScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupEmail,
          name: 'signupEmail',
          builder: (context, state) => const SignupEmailInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupEmailCode,
          name: 'signupEmailCode',
          builder: (context, state) => const SignupEmailCodeInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupPassword,
          name: 'signupPassword',
          builder: (context, state) => const SignupPasswordSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupNickname,
          name: 'signupNickname',
          builder: (context, state) => const SignupNicknameSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupProfileImage,
          name: 'signupProfileImage',
          builder: (context, state) => const SignupProfileImageSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupIntroduction,
          name: 'signupIntroduction',
          builder: (context, state) => const SignupIntroductionInputScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupMajorInterest,
          name: 'signupMajorInterest',
          builder: (context, state) => const SignupMajorInterestSetupScreen(),
        ),
        GoRoute(
          path: RoutePaths.signupComplete,
          name: 'signupComplete',
          builder: (context, state) => const SignupCompleteScreen(),
        ),
      ],
    ),
  ];
}
