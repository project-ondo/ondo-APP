import '../../entities/home/recommend_post_entity.dart';
import '../../repositories/home/home_repository.dart';

class LoadRecommendPostsUseCase {
  final HomeRepository homeRepository;

  LoadRecommendPostsUseCase({required this.homeRepository});

  //TODO : 정적 값 임시 삽입
  Future<List<PostEntity>> call() async {
    return (await homeRepository.getRecommendPostList(page: 0, size: 10))
        .map(
          (e) => PostEntity.fromPostModel(e),
        )
        .toList();
  }
}
