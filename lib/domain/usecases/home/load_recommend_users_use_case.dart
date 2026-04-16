import 'package:ondo/domain/entities/home/recommend_user_entity.dart';
import 'package:ondo/domain/repositories/search/user_repository.dart';

class LoadRecommendUsersUseCase {
  final UserRepository repository;

  LoadRecommendUsersUseCase({required this.repository});

  //TODO : 정적 값 임시 삽입
  Future<List<UserEntity>> call() async {
    return (await repository.getRecommendUserList(page: 0, size: 10))
        .map(
          (e) => UserEntity.fromUserModel(e),
        )
        .toList();
  }
}
