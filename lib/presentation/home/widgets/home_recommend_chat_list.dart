import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/base_home_profile_list.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

class HomeRecommendChatList extends BaseHomeProfileList {
  HomeRecommendChatList({super.key}) : super(title: "커피챗 추천");
  final HomeController _controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) => Obx(() => super.build(context));

  @override
  List<Widget> listBuilder() => _controller.viewProfileList
      .map(
        (chat) => HomeProfileCard(
          skill: chat.interests.first,
          name: chat.displayName,
          rating: chat.ratingCount,
        ),
      )
      .toList();
}
