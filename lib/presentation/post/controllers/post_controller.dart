import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostController extends GetxController {
  Future<Map<String, dynamic>?> enterPostDetail(
      BuildContext context,
      bool isMy,
      int postId, {
        bool isFavorite = false,
      }) async {
    final result = await context.push<Map<String, dynamic>>(
      '/post/$postId',
      extra: isFavorite,
    );
    return result;
  }
}