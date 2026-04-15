import 'package:get/get.dart';
import 'package:ondo/core/router/bindings/chat_binding.dart';
import 'package:ondo/core/router/bindings/community_binding.dart';
import 'package:ondo/core/router/bindings/home_binding.dart';
import 'package:ondo/presentation/navigation/controllers/navigation_controller.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

import '../../../presentation/alert/controllers/alert_controller.dart';
import '../../../presentation/search/controllers/main_top_bar_search_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<MainTopBarSearchController>(() => MainTopBarSearchController());
    Get.lazyPut<AlertController>(() => AlertController());
    Get.lazyPut(() => PostController());
    HomeBinding().dependencies();
    CommunityBinding().dependencies();
    ChatBinding().dependencies();
  }
}
