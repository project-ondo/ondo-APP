import 'package:ondo/domain/entities/chat/chat_entity.dart';
import 'package:ondo/domain/repositories/chat/chat_repository.dart';

class LoadMyChatRoomListUseCase {
  final ChatRepository repository;

  LoadMyChatRoomListUseCase({required this.repository});

  Future<List<ChatEntity>> call({required int size, required int page}) async {
    return await repository.loadMyChatRoomList(size, page);
  }
}
