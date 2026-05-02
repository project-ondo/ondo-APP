import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';

import '../../../data/models/post/response/post_detail_model.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';

class PostViewController extends GetxController {
  final int postId;
  final GetPostDetailUseCase _useCase;

  PostViewController({
    required this.postId,
    required GetPostDetailUseCase useCase,
  }) : _useCase = useCase;

  final Rx<PostDetailModel?> post = Rx<PostDetailModel?>(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final RxString title = ''.obs;
  final RxString authorName = ''.obs;
  final RxString bodyText = ''.obs;
  final RxList<String> postTags = <String>[].obs;
  final Rx<Duration> postAt = Duration.zero.obs;

  final RxBool selectHeart = false.obs;
  final RxBool selectBookMark = false.obs;

  final RxInt heartTotal = 0.obs;
  final RxInt bookMarkTotal = 0.obs;
  final RxInt commentCount = 0.obs;

  final RxList<Comment> comments = <Comment>[].obs;
  final RxList<PostInfo> postList = <PostInfo>[].obs;

  @override
  void onInit() {
    super.onInit();

    print('[PostViewController] onInit - postId: $postId');

    fetchPostDetail(postId);
  }

  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('[PostViewController] API 요청 시작 - postId: $postId');

      final result = await _useCase(postId);

      post.value = result;

      print(
        '[PostViewController] API 응답 성공 - title: ${result.title}',
      );

      title.value = result.title;
      authorName.value = result.authorName;
      bodyText.value = result.content;
      postTags.assignAll(result.tags);

      heartTotal.value = result.likeCount;
      commentCount.value = result.commentCount;
    } catch (e) {
      print('[PostViewController] API 요청 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void deletePostRequest() {}
}

typedef Comment = ({
String author,
String comment,
int heartTotal,
});