import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/router/bindings/community_binding.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/community/screens/community_main_screen.dart';
import 'package:ondo/presentation/community/screens/community_search_screen.dart';

class CommunityRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.community,
      builder: (context, state) {
        if (!Get.isRegistered<CommunityController>()) {
          CommunityBinding().dependencies();
        }
        return CommunityMainScreen();
      },
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) {
            return CommunitySearchScreen();
          },
        ),
      ],
    ),
  ];
}
