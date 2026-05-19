import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/bindings/home_search_binding.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/screens/home_search_screen.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

import '../../../presentation/home/screens/home_screen.dart';
import '../app_router.dart';
import '../bindings/home_binding.dart';

class HomeRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) {
        if (!Get.isRegistered<HomeController>()) {
          HomeBinding().dependencies();
        }
        return const HomeScreen();
      },
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) {
            //TODO : 만약 SearchState이 안 넘겨졌다면 redirect 요청
            final searchState = (state.extra as SearchState);
            HomeSearchBinding(state: searchState).dependencies();
            return HomeSearchScreen();
          },
        ),
      ],
    ),
  ];
}
