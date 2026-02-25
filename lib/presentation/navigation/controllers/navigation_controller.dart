import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final PageController pageController = PageController();

  void changeIndex(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChange(int index){
    currentIndex.value = index;
  }

  @override
  void onClose(){
    pageController.dispose();
    super.onClose();
  }
}
