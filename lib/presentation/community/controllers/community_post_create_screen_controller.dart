import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/core/utils/app_snackbar.dart';
import 'package:ondo/data/models/post/request/post_create_request_model.dart';
import 'package:ondo/data/models/post/request/post_update_request_model.dart';
import 'package:ondo/domain/usecases/post/create_post_usecase.dart';
import 'package:ondo/domain/usecases/post/update_post_usecase.dart';
import 'package:ondo/presentation/community/controllers/community_controller.dart';
import 'package:ondo/presentation/post/controllers/post_controller.dart';

class CommunityPostCreateController extends GetxController {
  final CreatePostUseCase _createUseCase;
  final UpdatePostUseCase _updateUseCase;

  final bool isEditMode;
  final int? editPostId;
  final String initialTitle;
  final String initialContent;
  final List<String> initialTags;

  CommunityPostCreateController({
    required CreatePostUseCase createUseCase,
    required UpdatePostUseCase updateUseCase,
    this.isEditMode = false,
    this.editPostId,
    this.initialTitle = '',
    this.initialContent = '',
    this.initialTags = const [],
  })  : _createUseCase = createUseCase,
        _updateUseCase = updateUseCase;

  late final TextEditingController titleController;
  late final TextEditingController contentController;

  final RxList<String> tags = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt contentLength = 0.obs;
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    titleController = TextEditingController(text: initialTitle);
    contentController = TextEditingController(text: initialContent);
    tags.assignAll(initialTags);
    titleController.addListener(_validate);
    contentController.addListener(() {
      contentLength.value = contentController.text.length;
      _validate();
    });
    _validate();
  }

  void _validate() {
    isFormValid.value =
        titleController.text.trim().isNotEmpty &&
            contentController.text.trim().isNotEmpty;
  }

  void addTag(String tag) {
    if (!tags.contains(tag)) tags.add(tag);
  }

  void removeTag(String tag) => tags.remove(tag);

  Future<void> submit(List<String> inputTags) async {
    if (isEditMode) {
      await _updatePost(inputTags);
    } else {
      await _createPost(inputTags);
    }
  }

  Future<void> _createPost(List<String> inputTags) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _createUseCase(
        PostCreateRequestModel(
          title: titleController.text,
          content: contentController.text,
          tags: inputTags,
        ),
      );
      Get.find<CommunityController>().refreshPosts();
      Get.back();
    } catch (e) {
      debugPrint('[CommunityPostCreateController] 게시물 작성 실패 - error: $e');
      AppSnackbar.showError('게시물 작성에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updatePost(List<String> inputTags) async {
    if (editPostId == null) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      await _updateUseCase(
        editPostId!,
        PostUpdateRequestModel(
          title: titleController.text,
          content: contentController.text,
          tags: inputTags,
        ),
      );
      Get.find<PostController>().notifyPostUpdated(
        editPostId!,
        titleController.text.trim(),
        inputTags,
      );
      Get.back();
    } catch (e) {
      debugPrint('[CommunityPostCreateController] 게시물 수정 실패 - error: $e');
      AppSnackbar.showError('게시물 수정에 실패했습니다. 다시 시도해 주세요.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}