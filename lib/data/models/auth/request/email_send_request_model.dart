class EmailSendRequestModel {
  final String email;

  const EmailSendRequestModel({required this.email});

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
