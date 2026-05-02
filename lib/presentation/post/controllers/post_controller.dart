import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class PostController extends GetxController {
  void enterPostDetail(
      BuildContext context,
      bool isMy,
      int postId,
      ) {
    context.push('/post/$postId');
  }
}