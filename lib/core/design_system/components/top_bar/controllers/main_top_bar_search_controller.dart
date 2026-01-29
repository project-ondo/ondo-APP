import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTopBarSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final SearchPopupController _searchPopupController = Get.put(SearchPopupController());

  Rx<bool> isShowPopUp = false.obs;

  @override
  void onInit() {
    focusNode.addListener(
      _isShowPopupToggle,
    );
    super.onInit();
  }

  void onTap() {
    focusNode.requestFocus();
  }

  void onOtherTap() {
    focusNode.unfocus();
  }

  void _isShowPopupToggle() {
    isShowPopUp.value = !isShowPopUp.value;
  }

  void onTyping(String text) {
    if (isShowPopUp.value) {
      _searchPopupController.typing(text);
    }
  }
}

class SearchPopupController extends GetxController {
  final List<String> loadTags = [
    "최근검색태그",
    "UI/UX",
    "Android",
    "멘토링",
    "팁",
    "공부인증",
  ];

  final List<String> loadTips = [
    "UIUX",
    "공부",
    "공부방법",
    "공부인증",
    "김유찬",
    "공부",
    "공부방법",
    "공부인증",
  ];

  Rx<List<String>> showTags = Rx([]);
  Rx<List<String>> showSearchTips = Rx([]);

  @override
  void onInit() {
    showTags.value = loadTags;
    showSearchTips.value = loadTips;

    super.onInit();
  }

  void typing(String text) {
    if (text.isNotEmpty) {
      showTags.value = List.of(
        loadTags.where((tag) => tag.toLowerCase().contains(text.toLowerCase())),
      );

      showSearchTips.value = List.of(
        loadTips.where((tip) => tip.toLowerCase().contains(text.toLowerCase())),
      );
    } else {
      showTags.value = loadTags;
      showSearchTips.value = loadTips;
    }
  }
}
