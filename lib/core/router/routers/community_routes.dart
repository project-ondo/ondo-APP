import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/router/bindings/community_binding.dart';
import 'package:ondo/core/router/bindings/community_search_binding.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/community/screens/community_main_screen.dart';
import 'package:ondo/presentation/community/screens/community_search_screen.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

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
            //TODO : 만약 SearchState이 안 넘겨졌다면 redirect 요청
            final searchState = state.extra as SearchState;
            CommunitySearchBinding(state: searchState).dependencies();
            return CommunitySearchScreen();
          },
        ),
      ],
    ),
  ];
}
