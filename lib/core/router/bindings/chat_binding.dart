import 'package:get/get.dart';
import 'package:ondo/presentation/chat/controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(),);
  }
}
