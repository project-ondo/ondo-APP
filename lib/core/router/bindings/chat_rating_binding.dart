import 'package:get/get.dart';
import 'package:ondo/data/datasource/rating/rating_remote_datasource.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/repositories/chat/chat_repository_impl.dart';
import 'package:ondo/data/repositories/rating/rating_repository_impl.dart';
import 'package:ondo/domain/usecases/chat/delete_chat_room_use_case.dart';
import 'package:ondo/domain/usecases/rating/rating_chat_room_use_case.dart';

import '../../../presentation/chat/controllers/chat_review_controller.dart';

class ChatRatingBinding extends Bindings {
  final String chatRoomId;

  ChatRatingBinding({required this.chatRoomId});

  @override
  void dependencies() {
    Get.lazyPut(
      () => RatingRemoteDatasource(client: Get.find<AuthClient>()),
    );

    Get.lazyPut(
      () => RatingRepositoryImpl(
        remoteDatasource: Get.find<RatingRemoteDatasource>(),
      ),
    );

    Get.lazyPut(
      () => RatingChatRoomUseCase(repository: Get.find<RatingRepositoryImpl>()),
    );

    Get.lazyPut(
      () => DeleteChatRoomUseCase(repository: Get.find<ChatRepositoryImpl>()),
    );

    Get.lazyPut(
      () => ChatReviewController(
        deleteChatRoomUseCase: Get.find<DeleteChatRoomUseCase>(),
        chatRoomId: chatRoomId,
        ratingChatRoomUseCase: Get.find<RatingChatRoomUseCase>(),
      ),
    );
  }
}
