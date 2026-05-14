import 'package:get/get.dart';
import 'package:ondo/data/repositories/chat/chat_repository_impl.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';

import '../../../domain/usecases/chat/read_chat_message_use_case.dart';

class ChatRoomBinding extends Bindings {
  final String chatRoomId;

  ChatRoomBinding({required this.chatRoomId});

  @override
  void dependencies() {
    Get.lazyPut<LoadChatRoomMessageUseCase>(
      () => LoadChatRoomMessageUseCase(
        repository: Get.find<ChatRepositoryImpl>(),
      ),
    );

    Get.lazyPut<DeleteChatRoomUseCase>(
      () => DeleteChatRoomUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );

    Get.lazyPut<ReadChatMessageUseCase>(
      () => ReadChatMessageUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );
    Get.put<ChatRoomController>(
      ChatRoomController(
        chatRoomId: chatRoomId,
        readChatMessageUseCase: Get.find<ReadChatMessageUseCase>(),
        loadChatRoomMessageUseCase: Get.find<LoadChatRoomMessageUseCase>(),
      ),
      tag: chatRoomId,
    );
  }
}
