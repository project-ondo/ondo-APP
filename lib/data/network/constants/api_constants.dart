import 'dart:developer';

import 'package:ondo/core/env.dart';

class ApiConstants {
  ApiConstants({required this.logName});

  final String logName;

  //.env 파일에서 설정한 환경 변수 불러오기
  static String get domain => Env.apiBaseUrl;

  static String get posts => "${Env.apiBaseUrl}/posts";

  static String get users => "${Env.apiBaseUrl}/users";

  static String get auth => "${Env.apiBaseUrl}/auth";

  static String get chats => "${Env.apiBaseUrl}/chat";

  static String get notification => "${Env.apiBaseUrl}/notifications";

  static const baseHeader = {"Content-Type": "application/json"};

  //TODO : 임시 로그인 데이터
  static String get loginId => Env.loginId;

  static String get loginPassword => Env.loginPassword;

  void errorLog(Object error) => log("$logName 서버 에러 : ${error.toString()}");

  void statusLog(int code) => log("$logName 서버 연결 상태 : $code");

  void successLog(bool success) => log("$logName 서버 성공 여부 : $success");

  void messageLog(String? message) => log("$logName 서버 메세지 : $message");
}
