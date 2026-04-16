//auth/signin
class SignInRequestModel {
  final String loginId;
  final String password;

  SignInRequestModel({required this.loginId, required this.password});

  Map toJson() => {"loginId": loginId, "password": password};
}

/*
{
"loginId": "75",
"password": "NkGE5JGElRQkZnu"
}
*/
