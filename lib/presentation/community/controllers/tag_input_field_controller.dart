import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TagInputController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final RxList<String> tags = <String>[].obs;

  void addTag(String value) {
    final tag = value.trim();
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      textController.clear();
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}