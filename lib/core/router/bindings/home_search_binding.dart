import 'package:get/get.dart';
import 'package:ondo/domain/usecases/search/user_search_use_case.dart';
import 'package:ondo/presentation/home/controllers/home_search_controller.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class HomeSearchBinding extends Bindings {
  final SearchState state;

  HomeSearchBinding({required this.state});

  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeSearchController(
        state: state,
        userSearchUseCase: Get.find<UserSearchUseCase>(),
      ),
    );
  }
}
