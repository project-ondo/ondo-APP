import 'package:get/get.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';
import 'package:ondo/data/network/websocket/chat_stomp_client.dart';
import 'package:ondo/data/repositories/chat/chat_repository_impl.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_chat_room_message_use_case.dart';
import 'package:ondo/domain/usecases/notification/show_local_notification_setting_use_case.dart';
import 'package:ondo/data/repositories/notification/notification_repository_impl.dart';
import 'package:ondo/presentation/chat/controllers/chat_room_controller.dart';

import '../../../domain/usecases/chat/read_chat_message_use_case.dart';

class ChatRoomBinding extends Bindings {
  final String chatRoomId;
  final String opponentDisplayName;
  final String? opponentProfileImageKey;

  ChatRoomBinding({
    required this.chatRoomId,
    this.opponentDisplayName = '',
    this.opponentProfileImageKey,
  });

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
    Get.lazyPut<ShowLocalNotificationUseCase>(
      () => ShowLocalNotificationUseCase(
        repository: Get.find<NotificationRepositoryImpl>(),
      ),
    );

    Get.put<ChatRoomController>(
      ChatRoomController(
        chatRoomId: chatRoomId,
        opponentDisplayName: opponentDisplayName,
        opponentProfileImageKey: opponentProfileImageKey,
        loadChatRoomMessageUseCase: Get.find<LoadChatRoomMessageUseCase>(),
        readChatMessageUseCase: Get.find<ReadChatMessageUseCase>(),
        stompClient: Get.find<ChatStompClient>(),
        authLocalDatasource: Get.find<AuthLocalDatasource>(),
        showLocalNotificationUseCase: Get.find<ShowLocalNotificationUseCase>(),
      ),
      tag: chatRoomId,
    );
  }
}
