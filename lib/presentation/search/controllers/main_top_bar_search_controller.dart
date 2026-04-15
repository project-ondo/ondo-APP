import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class MainTopBarSearchController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final RxBool showPopup = false.obs;
  final RxBool showResult = false.obs;

  late final List<String> _cacheTags;
  late final List<String> _cacheTips;

  final RxString tempQuery = "".obs;

  late final SearchState state;

  @override
  void onInit() {
    state = SearchState();
    _cacheTags = loadTags();
    _cacheTips = loadTips();
    super.onInit();
  }

  @override
  void onReady() {
    focusNode.addListener(_updateShowPopup);
    Get.lazyPut(() => SearchPopupController(mainController: this), fenix: true);
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
    state.query = value;
    _submit();
  }

  void onSubmitTip(String tip) {
    final trim = tip.trim();
    textController.text = trim;
    onSubmitText(trim);
  }

  void _submit() {
    searchUnfocus();
    showResult.value = true;
  }

  void selectTag(String value, bool isSelect) {
    isSelect ? state.tags.add(value) : state.tags.remove(value);
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
    viewTips.addAll(mainController._cacheTips);
    viewTags.addAll(mainController._cacheTags);
    //worker 등록
    worker1 = ever(
      mainController.tempQuery,
      _updateData,
    );
    super.onInit();
  }

  void _updateData(String text) {
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
