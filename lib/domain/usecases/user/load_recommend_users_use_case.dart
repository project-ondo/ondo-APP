import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/repositories/user/user_repository.dart';

class LoadRecommendUsersUseCase {
  final UserRepository repository;

  LoadRecommendUsersUseCase({required this.repository});

  Future<ListableWrapper<UserEntity>> call({int page = 0, int size = 10}) async {
    final res = await repository.getRecommendUserList(page: page, size: size);
    return ListableWrapper<UserEntity>(
      content: res.content.map(UserEntity.fromUserModel).toList(),
      page: res.page,
      size: res.size,
      totalElements: res.totalElements,
      totalPages: res.totalPages,
      last: res.last,
    );
  }
}
