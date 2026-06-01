import 'package:ondo/domain/entities/user/user_entity.dart';
import 'package:ondo/domain/repositories/user/user_repository.dart';

class UserSearchUseCase {
  final UserRepository repository;

  UserSearchUseCase({required this.repository});

  Future<List<UserEntity>> call({
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
    return res.map((e) => UserEntity.fromUserModel(e)).toList();
  }
}
