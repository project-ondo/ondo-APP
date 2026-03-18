import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> opacity;
  Duration animationDuration = Duration(milliseconds: 1300);

  final RxBool isReady = false.obs;
  final RxBool isLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    animationController.forward();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // TODO: 실제 로그인 여부 확인 로직 구현 필요
    isReady.value = true;
    isLogin.value = true;
  }

  @override
  void onClose() {
    super.onClose();
    animationController.dispose();
  }
}
