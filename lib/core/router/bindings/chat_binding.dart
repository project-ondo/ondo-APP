import 'package:get/get.dart';
import 'package:ondo/data/datasource/chat/chat_remote_datasource.dart';
import 'package:ondo/data/repositories/chat/chat_repository_impl.dart';
import 'package:ondo/domain/usecases/chat/load_my_chat_room_list_use_case.dart';
import 'package:ondo/presentation/chat/controllers/main_chat_controller.dart';

import '../../../data/network/clients/auth_client.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final dataSource = ChatRemoteDatasource(client: Get.find<AuthClient>());
    final repository = ChatRepositoryImpl(remoteDatasource: dataSource);

    final loadUseCase = LoadMyChatRoomListUseCase(repository: repository);

    ///chat 관련 dataSource 등록
    Get.lazyPut<ChatRemoteDatasource>(() => dataSource);

    ///chat 관련 repository 등록
    Get.lazyPut<ChatRepositoryImpl>(() => repository);

    ///나의 채팅방 목록 useCase 등록
    Get.lazyPut<LoadMyChatRoomListUseCase>(
      () => loadUseCase,
    );

    ///chat controller 등록
    Get.lazyPut(
      () => MainChatController(loadChatRoomsUseCase: loadUseCase),
    );
  }
}
