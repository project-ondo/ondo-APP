import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/search/states/search_state.dart';
import 'package:ondo/presentation/search/widgets/main_top_search_bar.dart';

class MainTopBarSearchController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  RxBool showPopup = false.obs;
  RxBool showResult = false.obs;

  late final List<String> cacheTags;
  late final List<String> cacheTips;

  final Set<String> selectTagList = {};
  final RxString tempQuery = "".obs;

  late final SearchState state;

  @override
  void onInit() {
    state = SearchState();
    cacheTags = loadTags();
    cacheTips = loadTips();
    print("a ${this.hashCode}");
    super.onInit();
  }

  @override
  void onReady() {
    focusNode.addListener(_updateShowPopup);
    super.onReady();
  }

  @override
  void onClose() {
    focusNode.removeListener(_updateShowPopup);
    textController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void searchFocus() => focusNode.requestFocus();

  void searchUnfocus() => focusNode.unfocus();

  void onSubmitText(String value) {
    state.query.value = value;
    _submit();
  }

  void onSubmitTip(String tip) {
    final trim = tip.trim();
    textController.text = trim;
    onSubmitText(trim);
  }

  void onSubmitTags() {
    state.tags.assignAll(selectTagList);
    _submit();
  }

  void _submit() {
    searchUnfocus();
    showResult.value = true;
  }

  void selectTag(String value, bool isSelect) {
    if (isSelect) {
      selectTagList.add(value);
      onSubmitTags();
    }
    {
      selectTagList.remove(value);
    }
  }

  void onChange(String value) {
    tempQuery.value = value;
  }

  void _updateShowPopup() => showPopup.value = focusNode.hasFocus;
}

class SearchPopupController extends GetxController {
  RxList<String> viewTags = <String>[].obs;
  RxList<String> viewTips = <String>[].obs;

  final MainTopBarSearchController mainController;

  late final Worker worker1;

  SearchPopupController({required this.mainController});

  @override
  void onInit() {
    //팁, 태그 보이기
    viewTips.addAll(mainController.cacheTips);
    viewTags.addAll(mainController.cacheTags);
    print("b ${mainController.hashCode}");
    //worker 등록
    worker1 = ever(
      mainController.tempQuery,
      _updateData,
    );
    super.onInit();
  }

  void _updateData(String text) {
    print(text);

    if (text.isNotEmpty) {
      //입력 걀과와 같은, 태그 20개 보이기
      viewTags.value = List.of(
        mainController.cacheTags
            .where(
              (tag) =>
                  tag.trim().toLowerCase().contains(text.trim().toLowerCase()),
            )
            .take(20),
      );
      //입력 걀과와 같은, 팁 20개 보이기
      viewTips.value = List.of(
        mainController.cacheTips
            .where(
              (tip) =>
                  tip.trim().toLowerCase().contains(text.trim().toLowerCase()),
            )
            .take(20),
      );
    } else {
      viewTags.value = mainController.cacheTags;
      viewTips.value = mainController.cacheTips;
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

  HomeSearchModel loadHomeResultData() => (
    chats: [
      {"": ""},
      {"": ""},
      {"": ""},
      {"": ""},
      {"": ""},
    ],
    posts: [
      {"": ""},
      {"": ""},
      {"": ""},
      {"": ""},
      {"": ""},
    ],
  );

  CommunitySearchModel? loadCommunityResultData() => (
    posts: [
      {},
      {},
      {},
      {},
      {},
    ],
  );
}
