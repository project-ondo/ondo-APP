import 'package:get/get.dart';
import 'package:ondo/data/datasource/chat/chat_remote_datasource.dart';
import 'package:ondo/data/repositories/chat/chat_repository_impl.dart';
import 'package:ondo/domain/usecases/chat/block_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/create_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/presentation/chat/controllers/chat_main_controller.dart';

import '../../../data/network/clients/auth_client.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    ///chat 관련 dataSource 등록
    Get.lazyPut<ChatRemoteDatasource>(
      () => ChatRemoteDatasource(client: Get.find<AuthClient>()),
    );

    ///chat 관련 repository 등록
    Get.lazyPut<ChatRepositoryImpl>(
      () => ChatRepositoryImpl(
        remoteDatasource: Get.find<ChatRemoteDatasource>(),
      ),
    );

    ///나의 채팅방 목록 useCase 등록
    Get.lazyPut<LoadMyChatRoomListUseCase>(
      () =>
          LoadMyChatRoomListUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );
    Get.lazyPut<CreateChatRoomUseCase>(
      () => CreateChatRoomUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );
    Get.lazyPut<BlockChatRoomUseCase>(
      () => BlockChatRoomUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );

    ///chat controller 등록
    Get.lazyPut(
      () => ChatMainController(
        blockChatRoomUseCase: Get.find<BlockChatRoomUseCase>(),
        loadChatRoomsUseCase: Get.find<LoadMyChatRoomListUseCase>(),
      ),
    );
  }
}
