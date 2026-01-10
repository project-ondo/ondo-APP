import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutePaths {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.home,
  routes: [
    GoRoute(
      path: RoutePaths.home,
      name: 'home',
      builder: (context, state) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('홈페이지'),
            ElevatedButton(
              onPressed: () => context.goNamed('login'),
              child: Text('로그인'),
            ),
          ],
        ),
      ),
    ),
    GoRoute(
      path: RoutePaths.login,
      name: 'login',
      builder: (context, state) => Scaffold(
        body: Text('로그인페이지'),
      ),
    ),
    GoRoute(
      path: RoutePaths.profile,
      name: 'profile',
      builder: (context, state) => Scaffold(
        body: Text('프로필'),
      ),
    ),
    GoRoute(
      path: RoutePaths.signup,
      name: 'signup',
      builder: (context, state) => Scaffold(
        body: Text('회원가입페이지'),
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('페이지르 찾을 수 없습니다.'),
    ),
  ),
);
