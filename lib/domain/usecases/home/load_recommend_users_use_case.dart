import 'package:ondo/domain/entities/home/recommend_user_entity.dart';
import 'package:ondo/domain/repositories/home/home_repository.dart';

class LoadRecommendUsersUseCase {
  final HomeRepository homeRepository;

  LoadRecommendUsersUseCase({required this.homeRepository});

  //TODO : 정적 값 임시 삽입
  Future<List<UserEntity>> call() async {
    return (await homeRepository.getRecommendUserList(page: 0, size: 10))
        .map(
          (e) => UserEntity.fromUserModel(e),
        )
        .toList();
  }
}
