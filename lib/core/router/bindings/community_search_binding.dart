import 'package:get/get.dart';
import 'package:ondo/presentation/community/controllers/community_search_controller.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class CommunitySearchBinding extends Bindings {
  final SearchState state;

  CommunitySearchBinding({required this.state});

  @override
  void dependencies() {
    Get.lazyPut(
      () => CommunitySearchController(state: state),
    );
  }
}
