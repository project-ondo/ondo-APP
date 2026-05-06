import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ondo/presentation/community/controllers/tag_input_field_controller.dart';

class CommunityPostCreateController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final contentLength = 0.obs;
  final isFormValid = false.obs;

  // 수정 모드
  final bool isEditMode;
  final int? editPostId;

  CommunityPostCreateController({
    this.isEditMode = false,
    this.editPostId,
    String initialTitle = '',
    String initialContent = '',
    List<String> initialTags = const [],
  }) {
    titleController.text = initialTitle;
    contentController.text = initialContent;
    _initialTags = initialTags;
  }

  List<String> _initialTags = [];
  late final TagInputController _tagController;

  @override
  void onInit() {
    super.onInit();
    _tagController = Get.find<TagInputController>();

    // 수정 모드일 때 태그 초기값 세팅
    if (_initialTags.isNotEmpty) {
      _tagController.tags.assignAll(_initialTags);
    }

    titleController.addListener(_validateForm);
    contentController.addListener(() {
      contentLength.value = contentController.text.length;
      _validateForm();
    });
    ever(_tagController.tags, (_) => _validateForm());

    // 수정 모드일 때 초기 길이 세팅
    contentLength.value = contentController.text.length;
    _validateForm();
  }

  void _validateForm() {
    isFormValid.value =
        titleController.text.isNotEmpty &&
            contentController.text.isNotEmpty &&
            _tagController.tags.isNotEmpty;
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    Get.delete<TagInputController>();
    super.onClose();
  }
}