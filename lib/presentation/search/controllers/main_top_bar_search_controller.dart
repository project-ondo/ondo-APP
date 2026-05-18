import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ondo/core/router/app_router.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class MainTopBarSearchController extends GetxController {
  late final TextEditingController searchController;

  final RxBool showPopup = false.obs;

  late final List<String> _cacheTags;
  late final List<String> _cacheTips;

  final Rx<SearchState> state = Rx(SearchState.none());

  @override
  void onInit() {
    searchController = TextEditingController();
    _cacheTags = loadTags();
    _cacheTips = loadTips();
    super.onInit();
  }

  @override
  void onReady() {
    Get.lazyPut(() => SearchPopupController(mainController: this), fenix: true);
    super.onReady();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void unfocusSearchBar() => showPopup.value = false;

  void focusSearchBar() => showPopup.value = true;

  void onSubmit(BuildContext context, {String? keyword, List<String>? tags}) {
    if (keyword != null) {
      state.value = state.value.copyWith(keyword: keyword);
    }
    if (tags != null) {
      state.value = state.value.copyWith(tags: tags);
    }

    final location = GoRouterState.of(context).uri.path;

    String searchPath = "search";

    if (location.startsWith(RoutePaths.home)) {
      searchPath = RoutePaths.homeSearch;
    } else if (location.startsWith(RoutePaths.chat)) {
      searchPath = RoutePaths.chatSearch;
    } else if (location.startsWith(RoutePaths.community)) {
      searchPath = RoutePaths.communitySearch;
    }

    //TODO : 않을 경우 예외 처리

    showPopup.value = false;
    context.go(searchPath, extra: state.value);
  }

  void selectTag(String value, bool isSelect) {
    isSelect ? state.value.tags.add(value) : state.value.tags.remove(value);
  }

  void onChange(String value) {
    state.value = state.value.copyWith(keyword: value);
  }
}

class SearchPopupController extends GetxController {
  RxList<String> viewTags = <String>[].obs;
  RxList<String> viewTips = <String>[].obs;

  final MainTopBarSearchController mainController;

  late final Worker searchUpdateWorker;

  SearchPopupController({required this.mainController});

  @override
  void onInit() {
    //팁, 태그 보이기
    viewTips.addAll(mainController._cacheTips);
    viewTags.addAll(mainController._cacheTags);
    //worker 등록
    searchUpdateWorker = ever(
      mainController.state,
      _update,
    );
    super.onInit();
  }

  void _update(SearchState state) {
    final text = state.keyword;

    if (text.isNotEmpty) {
      //입력 걀과와 같은, 태그 20개 보이기
      viewTags.value = List.of(
        mainController._cacheTags
            .where(
              (tag) =>
                  tag.trim().toLowerCase().contains(text.trim().toLowerCase()),
            )
            .take(20),
      );
      //입력 걀과와 같은, 팁 20개 보이기
      viewTips.value = List.of(
        mainController._cacheTips
            .where(
              (tip) =>
                  tip.trim().toLowerCase().contains(text.trim().toLowerCase()),
            )
            .take(20),
      );
    } else {
      viewTags.value = mainController._cacheTags;
      viewTips.value = mainController._cacheTips;
    }
  }
}

extension DummyMoel on MainTopBarSearchController {
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
