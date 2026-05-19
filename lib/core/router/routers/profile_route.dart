import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/presentation/profile/controllers/my_profile_controller.dart';

import '../../../presentation/profile/screens/edit_profile_screen.dart';
import '../../../presentation/profile/screens/my_profile_screen.dart';
import '../../../presentation/profile/screens/other_profile_screen.dart';
import '../../../presentation/profile/screens/setting_screen.dart';
import '../../../presentation/profile/screens/terms_screen.dart';
import '../app_router.dart';
import '../bindings/profile_binding.dart';

class ProfileRoute {
  static List<RouteBase> get routes => [
    ShellRoute(
      builder: (context, state, child) {
        if (!Get.isRegistered<MyProfileController>()) {
          ProfileBinding().dependencies();
        }
        return child;
      },
      routes: [
        GoRoute(
          path: RoutePaths.profile,
          name: 'profile',
          builder: (context, state) => const MyProfileScreen(),
          routes: [
            GoRoute(
              path: 'edit',
              name: 'editProfile',
              builder: (context, state) => const EditProfileScreen(),
            ),
            GoRoute(
              path: 'setting',
              name: 'profileSetting',
              builder: (context, state) => const SettingScreen(),
              routes: [
                GoRoute(
                  path: 'terms',
                  name: 'profileTerms',
                  builder: (context, state) => const TermsScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'user/:publicId',
              name: 'userProfile',
              builder: (context, state) => OtherProfileScreen(
                publicId: state.pathParameters['publicId'] ?? '',
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}
