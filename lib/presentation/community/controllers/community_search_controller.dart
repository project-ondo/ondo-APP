import 'package:get/get.dart';
import 'package:ondo/domain/entities/post/post_entity.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class CommunitySearchController extends GetxController {
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;

  final SearchState state;

  CommunitySearchController({required this.state});

  @override
  void onInit() {
    _initSearchPostList();
    super.onInit();
  }

  Future _initSearchPostList() async {
    //TODO : searchPost 로직 추가
  }
}
