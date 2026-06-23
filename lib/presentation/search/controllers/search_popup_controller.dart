import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ondo/domain/usecases/search/load_search_keyword_list_use_case.dart';

import 'main_top_bar_search_controller.dart';

class SearchPopupController extends GetxController {
  final LoadSearchKeywordListUseCase loadSearchKeywordListUseCase;

  SearchPopupController({
    required this.mainTopBarSearchController,
    required this.loadSearchKeywordListUseCase,
  });

  RxSet<String> viewSearchTagList = <String>{}.obs;
  RxSet<String> viewSearchTipList = <String>{}.obs;

  final Set<String> _cacheSearchTipList = {};

  final MainTopBarSearchController mainTopBarSearchController;

  late final Worker typingWorker;
  late final Worker showPopupWorker;

  // submit이 발생한 횟수 기준으로 마지막 태그 로드 시점 추적
  // -1: 아직 한 번도 로드 안 함 → onInit에서 무조건 1회 로드
  int _lastLoadedAtSubmitCount = -1;

  @override
  void onInit() {
    //TODO 삭제
    _cacheSearchTipList.assignAll(loadTips());

    /// 태그, 추천 검색어 불러오기
    //TODO : 서버로부터 추천 키워드 받기
    viewSearchTipList.assignAll(_cacheSearchTipList.take(20));

    // 초기 1회 로드
    _loadTagsIfNeeded();

    /// worker 등록
    typingWorker = ever(
      mainTopBarSearchController.queryNotifier,
      _update,
    );
    // 팝업이 열릴 때 새 검색어가 저장된 경우에만 재로드
    showPopupWorker = ever(
      mainTopBarSearchController.showPopup,
      (bool show) { if (show) _loadTagsIfNeeded(); },
    );

    super.onInit();
  }

  @override
  void onClose() {
    typingWorker.dispose();
    showPopupWorker.dispose();
    super.onClose();
  }

  /// submit 이후 새 태그가 저장됐을 때만 로컬 스토리지 재조회
  Future<void> _loadTagsIfNeeded() async {
    final currentSubmitCount = mainTopBarSearchController.submitCount.value;
    if (currentSubmitCount == _lastLoadedAtSubmitCount) return;

    _lastLoadedAtSubmitCount = currentSubmitCount;
    final result = await loadSearchKeywordListUseCase.call();
    viewSearchTagList.assignAll(result);
    debugPrint("로컬, 최근 검색 태그 불러오기 성공");
  }

  void selectSearchTag(String tag) {
    mainTopBarSearchController.submitFromSuggestion(tag);
  }

  void selectSearchTip(String tip) {
    mainTopBarSearchController.submitFromSuggestion(tip);
  }

  void _update(String text) {
    /// 값이 비면, 전체 표시
    if (text.isEmpty) {
      viewSearchTipList.assignAll(_cacheSearchTipList);
      return;
    }

    final matchingTipList = _cacheSearchTipList.where(
      (tip) => tip.trim().toLowerCase().contains(text.trim().toLowerCase()),
    );

    /// 매칭되는 게 없으면, 전체 표시
    if (matchingTipList.isEmpty) {
      viewSearchTipList.assignAll(_cacheSearchTipList);
      return;
    }

    /// 최대 20개
    viewSearchTipList.assignAll(matchingTipList.take(20));
  }
}

extension DummyMoel on SearchPopupController {
  List<String> loadTags() => [
    "최근검색태그",
    "UI/UX",
    "Android",
    "멘토링",
    "팁",
    "공부인증",
  ];

  List<String> loadTips() => [
    "UIUX",
    "공부",
    "공부방법",
    "공부인증",
    "김유찬",
    "공부",
    "공부방법",
    "공부인증",
  ];
}
