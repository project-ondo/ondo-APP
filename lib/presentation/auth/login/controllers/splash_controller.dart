import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final AuthLocalDatasource localDatasource;

  SplashController({required this.localDatasource});

  late final AnimationController animationController;
  late final Animation<double> opacity;
  Duration animationDuration = const Duration(milliseconds: 1300);

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

    isLogin.value = await _checkLoginStatus();
    isReady.value = true;
  }

  /// 저장된 토큰 유효성 확인
  Future<bool> _checkLoginStatus() async {
    final token = await localDatasource.getAccessToken();
    if (token == null || token.isEmpty) return false;

    final expirationStr = await localDatasource.getAccessTokenExpiration();
    if (expirationStr == null) return false;

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null) return false;

    // refreshToken도 확인
    final refreshToken = await localDatasource.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final refreshExpirationStr =
    await localDatasource.getRefreshTokenExpiration();
    if (refreshExpirationStr == null) return false;

    final refreshExpiration = DateTime.tryParse(refreshExpirationStr);
    if (refreshExpiration == null) return false;

    // refreshToken이 유효하면 로그인 상태로 간주
    return DateTime.now().isBefore(refreshExpiration);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}