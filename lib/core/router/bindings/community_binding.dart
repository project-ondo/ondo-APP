import 'package:get/get.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';

class CommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CommunityController(),
    );
  }
}
