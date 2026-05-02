import 'package:get/get.dart';
import 'package:ondo/data/datasource/%20post/post_remote_datasource.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import '../../../data/models/post/response/post_detail_model.dart';
import '../../../data/network/clients/auth_client.dart';
import '../../../data/repositories/post/post_repository_impl.dart';
import '../../../domain/usecases/post/get_post_detail_usecase.dart';

class PostViewController extends GetxController {
  final int postId;
  PostViewController({required this.postId});

  late GetPostDetailUseCase _useCase;

  final Rx<PostDetailModel?> post = Rx(null);
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  RxString title = ''.obs;
  RxString authorName = ''.obs;
  RxString bodyText = ''.obs;
  RxList<String> postTags = <String>[].obs;
  Rx<Duration> postAt = Duration().obs;
  bool selectHeart = false;
  bool selectBookMark = false;
  int heartTotal = 0;
  int bookMarkTotal = 0;
  int commentCount = 0;
  RxList<Comment> comments = <Comment>[].obs;
  RxList<PostInfo> postList = <PostInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    _useCase = GetPostDetailUseCase(
      PostRepositoryImpl(
        PostRemoteDatasourceImpl(Get.find<AuthClient>()),
      ),
    );
    print('[PostViewController] onInit - postId: $postId');
    fetchPostDetail(postId);
  }

  Future<void> fetchPostDetail(int postId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      print('[PostViewController] API 요청 시작 - postId: $postId');
      post.value = await _useCase(postId);
      print('[PostViewController] API 응답 성공 - title: ${post.value?.title}');
      title.value = post.value?.title ?? '';
      authorName.value = post.value?.authorName ?? '';
      bodyText.value = post.value?.content ?? '';
      postTags.value = post.value?.tags ?? [];
      heartTotal = post.value?.likeCount ?? 0;
      commentCount = post.value?.commentCount ?? 0;
    } catch (e) {
      print('[PostViewController] API 요청 실패 - error: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void deletePostRequest() {}
}

typedef Comment = ({String author, String comment, int heartTotal});