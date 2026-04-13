class ApiConstants {
  ApiConstants._();

  static const domain = "https://ondo.o-r.kr";
  static const posts = "$domain/posts";
  static const users = "$domain/users";

  static const baseHeader = {"Content-Type": "application/json"};

  static final postUri = Uri.parse(posts);
  static final userUri = Uri.parse(users);

  //TODO : 임시 로그인 데이터
  static String loginId = "94/94";
  static String loginPassword = "4X8zB27Ommwktsm";
}
