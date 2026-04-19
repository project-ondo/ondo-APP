class PresignUploadRequestModel {
  final String category;
  final String contentType;

  const PresignUploadRequestModel({
    required this.category,
    required this.contentType,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'contentType': contentType,
  };
}