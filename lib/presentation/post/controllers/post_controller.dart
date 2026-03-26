import 'package:get/get.dart';
import 'package:ondo/presentation/post/controllers/post_view_controller.dart';
import 'package:ondo/presentation/post/screens/post_detail_screen.dart';

//TODO : 모든 PostItem을 사용하는 page는 해당 PostController가 Get.put이 되어 있어야 함
class PostController extends GetxController {
  void enterPostDetail(bool isMy) {
    //게시물에 대한 정보를 서버로부터 불러와, 전달
    //TODO : Post Model이 정의되었을 떄 해당하는 id 값을 바탕으로 controller 등록 및 id 전달
    Get.lazyPut(() => PostViewController());
    Get.to(isMy ? PostDetailScreen.myPost() : PostDetailScreen.otherPost());
  }
}
