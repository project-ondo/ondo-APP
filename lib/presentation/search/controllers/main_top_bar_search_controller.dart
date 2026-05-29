import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/domain/usecases/search/save_search_keyword_use_case.dart';
import 'package:ondo/presentation/search/states/search_state.dart';

class MainTopBarSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final SearchState state = SearchState();

  final SaveSearchKeywordUseCase saveSearchKeywordUseCase;

  MainTopBarSearchController({required this.saveSearchKeywordUseCase});

  final RxBool showPopup = false.obs;
  final RxBool showResult = false.obs;

  final RxString queryNotifier = "".obs;

  @override
  void onInit() {
    focusNode.addListener(_updatePopup);
    searchController.addListener(_updateQuery);
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.removeListener(_updatePopup);
    searchController.removeListener(_updateQuery);
    super.onClose();
  }

  Future<void> _saveSearchTag(String keyword) async {
    /// 로컬 저장
    final success = await saveSearchKeywordUseCase.call(keyword);
    debugPrint("최근 검색 태그, 로컬 저장 ${success ? '성공' : '실패'}");
  }

  void submit({String? query, String? tag, String? tip}) {
    focusNode.unfocus();
    state.setKeyword(query: query, tag: tag, tip: tip);
    if (state.keyword.isEmpty) {
      showResult.value = false;
      return;
    }
    showResult.value = true;
    _saveSearchTag(state.keyword);
  }

  void tapOther() => focusNode.unfocus();

  void tapSearchBar() => focusNode.requestFocus();

  void _updateQuery() {
    queryNotifier.value = searchController.text;
    if(searchController.text.isEmpty) {
      showResult.value = false;
      state.clear();
    }
  }

  void _updatePopup() => showPopup.value = focusNode.hasFocus;
}
