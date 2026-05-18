import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/core/router/bindings/chat_binding.dart';
import 'package:ondo/presentation/chat/controllers/chat_main_controller.dart';
import 'package:ondo/presentation/chat/screens/chat_main_screen.dart';

class ChatRoutes {
  static List<RouteBase> routes = [
    GoRoute(
      path: RoutePaths.chat,
      builder: (context, state) {
        if (!Get.isRegistered<ChatMainController>()) {
          ChatBinding().dependencies();
        }
        return ChatMainScreen();
      },
      routes: [
        GoRoute(
          path: 'search',
          builder: (context, state) {
            //TODO : 채팅 검색 구조 변경
            return SizedBox();
          },
        ),
      ],
    ),
  ];
}
