import 'package:get/get.dart';
import 'package:ondo/data/datasource/search/search_local_data_source.dart';
import 'package:ondo/data/repositories/search/search_repository_impl.dart';
import 'package:ondo/domain/usecases/search/load_search_keyword_list_use_case.dart';
import 'package:ondo/domain/usecases/search/save_search_keyword_use_case.dart';
import 'package:ondo/presentation/search/controllers/main_top_bar_search_controller.dart';
import 'package:ondo/presentation/search/controllers/search_popup_controller.dart';
import 'package:ondo/presentation/search/states/search_page_state.dart';

class SearchBinding extends Bindings {
  final SearchPageState pageState;

  SearchBinding({required this.pageState});

  @override
  void dependencies() {
    Get.lazyPut<SearchLocalDataSource>(
      () => SearchLocalDataSource(),
    );
    Get.lazyPut<SearchRepositoryImpl>(
      () => SearchRepositoryImpl(
        localDataSource: Get.find<SearchLocalDataSource>(),
      ),
    );
    Get.lazyPut<LoadSearchKeywordListUseCase>(
      () => LoadSearchKeywordListUseCase(
        repository: Get.find<SearchRepositoryImpl>(),
      ),
    );
    Get.lazyPut<SaveSearchKeywordUseCase>(
      () => SaveSearchKeywordUseCase(
        repository: Get.find<SearchRepositoryImpl>(),
      ),
    );

    Get.lazyPut<MainTopBarSearchController>(
      () => MainTopBarSearchController(
        saveSearchKeywordUseCase: Get.find<SaveSearchKeywordUseCase>(),
      ),
      tag: pageState.id,
      fenix: true,
    );
    Get.lazyPut<SearchPopupController>(
      () => SearchPopupController(
        mainTopBarSearchController: Get.find<MainTopBarSearchController>(
          tag: pageState.id,
        ),
        loadSearchKeywordListUseCase: Get.find<LoadSearchKeywordListUseCase>(),
      ),
      tag: pageState.id,
      fenix: true,
    );
  }
}
