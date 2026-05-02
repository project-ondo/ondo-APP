import 'package:get/get.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/screens/post_detail_screen.dart';

class PostController extends GetxController {
  void enterPostDetail(bool isMy, int postId) {
    print('[PostController] enterPostDetail - postId: $postId');
    Get.delete<PostViewController>(force: true);
    Get.put(PostViewController(postId: postId));
    Get.to(
      isMy ? PostDetailScreen.myPost() : PostDetailScreen.otherPost(),
    );
  }
}