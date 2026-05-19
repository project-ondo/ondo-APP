import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

import '../../../domain/entities/post/post_entity.dart';
import '../../../domain/entities/user/user_entity.dart';

class HomeSearchController extends GetxController {
  final RxList<UserEntity> viewUserList = <UserEntity>[].obs;
  final RxList<PostEntity> viewPostList = <PostEntity>[].obs;

  final SearchState state;
  final UserSearchUseCase userSearchUseCase;

  HomeSearchController({required this.userSearchUseCase, required this.state});

  @override
  void onInit() {
    _searchUsers();
    _searchPosts();
    super.onInit();
  }

  Future _searchUsers() async {
    viewUserList.assignAll(
      await userSearchUseCase.call(
        keyword: state.keyword,
        interests: state.tags.toList(),
      ),
    );
  }

  Future _searchPosts() async {
    //TODO : SearchPost 로직 추가
  }
}
