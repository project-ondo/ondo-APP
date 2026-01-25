import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopBarSearchController extends GetxController {
  final TextEditingController searchTextController = TextEditingController();

  Rx<bool> isShowPopUp = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void onTap() {
    Get.put(SearchPopUpController());
    isShowPopUp.value = true;
  }
}

class SearchPopUpController extends GetxController {
  final List<String> _tagList = [
    "최근검색태그",
    "UI/UX",
    "Android",
    "멘토링",
    "팁",
    "공부인증",
  ];

  final List<String> _searchTipList = [
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
    showTags.value = _tagList;
    showSearchTips.value = _searchTipList;

    super.onInit();
  }

  void typing(String text) {
    if (text.isNotEmpty) {
      showTags.value = List.of(
        _tagList.where((tag) => tag.toLowerCase().contains(text.toLowerCase())),
      );

      showSearchTips.value = List.of(
        _searchTipList.where(
          (tip) {
            print(tip);
            return tip.toLowerCase().contains(text.toLowerCase());
          },
        ),
      );
    } else {
      showTags.value = _tagList;
      showSearchTips.value = _searchTipList;
    }
  }
}
