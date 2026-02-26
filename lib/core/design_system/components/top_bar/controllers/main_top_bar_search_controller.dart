import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTopBarSearchController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late SearchPopupController _popupController;

  RxBool showResult = false.obs;
  RxBool showSearchPopup = false.obs;

  RxList<String> searchTags = <String>[].obs;
  RxList<String> searchTips = <String>[].obs;

  @override
  void onInit() {
    searchTags.addAll(loadTags());
    searchTips.addAll(loadTips());
    super.onInit();
  }

  @override
  void onReady() {
    focusNode.addListener(_isShowPopupToggle);
    super.onReady();
  }

  void onTap() => focusNode.requestFocus();

  void onOtherTap() => focusNode.unfocus();

  void onChange(String text) {
    _ensureIsRegisterPopController(() {
      _popupController.searchFitsKeywords(text);
    });
  }

  void onSubmit(String value) {
    _ensureIsRegisterPopController(() {
      if (textController.text.isNotEmpty) {
        showResult.value = true;
      }
    });
  }

  void _isShowPopupToggle() {
    if (focusNode.hasFocus) {
      if (!Get.isRegistered<SearchPopupController>()) {
        _popupController = Get.put(SearchPopupController());
      } else {
        _popupController = Get.find<SearchPopupController>();
      }
      showSearchPopup.value = true;
    } else {
      showSearchPopup.value = false;
    }
  }

  void _ensureIsRegisterPopController(Function callBack) {
    if (Get.isRegistered<SearchPopupController>()) {
      callBack.call();
    }
  }

  T? checkResultDataType<T>() {
    if (T == HomeSearchModel) {
      return _loadHomeResultData() as T;
    }
    if (T == CommunitySearchModel) {
      return _loadCommunityResultData() as T;
    }
    return null;
  }

  HomeSearchModel _loadHomeResultData() => (
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

  CommunitySearchModel? _loadCommunityResultData() => (
    posts: [
      {},
      {},
      {},
      {},
      {},
    ],
  );
}

typedef HomeSearchModel = ({
  List<Map<String, dynamic>> chats,
  List<Map<String, dynamic>> posts,
});
typedef CommunitySearchModel = ({
  List<Map<String, dynamic>> posts,
});
typedef ChatSearchModel = ({
  List<Map<String, dynamic>> chats,
});

class SearchPopupController extends GetxController {
  RxList<String> tempSearchTags = <String>[].obs;
  RxList<String> tempSearchTips = <String>[].obs;

  Set<String> selectTags = {};
  Set<String> selectTips = {};

  late final MainTopBarSearchController _controller;

  @override
  void onInit() {
    _controller = Get.find<MainTopBarSearchController>();
    tempSearchTips.addAll(_controller.searchTips);
    tempSearchTags.addAll(_controller.searchTags);
    super.onInit();
  }

  void searchFitsKeywords(String text) {
    if (text.isNotEmpty) {
      tempSearchTags.value = List.of(
        _controller.searchTags.where(
          (tag) => tag.toLowerCase().contains(text.toLowerCase()),
        ),
      );
      tempSearchTips.value = List.of(
        _controller.searchTips.where(
          (tip) => tip.toLowerCase().contains(text.toLowerCase()),
        ),
      );
    } else {
      tempSearchTags.value = _controller.searchTags;
      tempSearchTips.value = _controller.searchTips;
    }
  }

  void selectTag(int index, bool isSelect) => isSelect
      ? selectTags.add(tempSearchTags[index])
      : selectTags.remove(tempSearchTags[index]);

  void selectTip(int index, bool isSelect) => isSelect
      ? selectTips.add(tempSearchTips[index])
      : selectTips.remove(tempSearchTips[index]);
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
