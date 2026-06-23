import 'package:ondo/domain/entities/base/listable_wrapper.dart';
import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/repositories/user/user_repository.dart';

class UserSearchUseCase {
  final UserRepository repository;

  UserSearchUseCase({required this.repository});

  Future<ListableWrapper<UserEntity>> call({
    String? keyword,
    String? major,
    List<String>? interests,
    String? sort,
    int? page,
    int? size,
  }) async {
    final res = await repository.search(
      size: size,
      page: page,
      interests: interests,
      keyword: keyword,
      major: major,
      sort: sort,
    );
    return ListableWrapper<UserEntity>(
      content: res.content.map((e) => UserEntity.fromUserModel(e)).toList(),
      page: res.page,
      size: res.size,
      totalElements: res.totalElements,
      totalPages: res.totalPages,
      last: res.last,
    );
  }
}
