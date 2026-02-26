import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:ondo/presentation/community/controllers/tag_input_field_controller.dart';

class CommunityPostCreateController extends GetxController {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final contentLength = 0.obs;
  final isFormValid = false.obs;

  late final TagInputController _tagController;

  @override
  void onInit() {
    super.onInit();
    _tagController = Get.find<TagInputController>();

    titleController.addListener(_validateForm);
    contentController.addListener(() {
      contentLength.value = contentController.text.length;
      _validateForm();
    });
    ever(_tagController.tags, (_) => _validateForm());
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