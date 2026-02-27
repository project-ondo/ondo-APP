import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondo/presentation/home/controllers/home_controller.dart';
import 'package:ondo/presentation/home/widgets/base_home_profile_list.dart';
import 'package:ondo/presentation/home/widgets/home_profile_card.dart';

@immutable
class HomeRecommendChatList extends BaseHomeProfileList {
  HomeRecommendChatList({super.key}) : super(title: "커피챗 추천");
  final HomeController _controller = Get.find<HomeController>();

  @override
  List<Widget> listBuilder() => List.generate(
    _controller.chats.length,
    (index) {
      final chat = _controller.chats[index];
      return HomeProfileCard(
        skill: chat.skill,
        name: chat.name,
        rating: chat.rating,
      );
    },
  );
}
