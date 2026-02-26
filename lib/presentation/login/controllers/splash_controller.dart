  import 'package:flutter/animation.dart';
  import 'package:get/get.dart';

  class SplashController extends GetxController
      with GetSingleTickerProviderStateMixin {
    late final AnimationController animationController;
    Animation<double>? opacity;

    final RxBool isReady = false.obs;
    final RxBool isLogin = false.obs;

    @override
    void onInit() {
      super.onInit();
      animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1300),
      );
      opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn),
      );

      animationController.forward();
      _bootstrap();
    }

    Future<void> _bootstrap() async {
      await Future.delayed(Duration(milliseconds: 1500));

      isReady.value = true;
      isLogin.value = true;
    }

    @override
    void onClose() {
      super.onClose();
      animationController.dispose();
    }
  }
