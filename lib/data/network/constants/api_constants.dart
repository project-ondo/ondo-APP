import 'dart:developer';

class ApiConstants {
  ApiConstants({required this.logName});

  final String logName;

  static const domain = "https://ondo.o-r.kr";
  static const posts = "$domain/posts";
  static const users = "$domain/users";
  static const auth = "$domain/auth";

  static const baseHeader = {"Content-Type": "application/json"};


  //TODO : 임시 로그인 데이터
  static String loginId = "94/94";
  static String loginPassword = "4X8zB27Ommwktsm";

  void errorLog(Object error) => log("$logName 서버 에러 : ${error.toString()}");

  void statusLog(int code) => log("$logName 서버 연결 상태 : $code");

  void successLog(bool success) => log("$logName 서버 성공 여부 : $success");

  void messageLog(String message) => log("$logName 서버 메세지 : $message");
}
