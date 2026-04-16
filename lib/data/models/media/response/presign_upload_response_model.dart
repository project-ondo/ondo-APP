class PresignUploadResponseModel {
  final bool success;
  final String message;
  final PresignUploadData? data;

  PresignUploadResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory PresignUploadResponseModel.fromJson(Map json) {
    return PresignUploadResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? PresignUploadData.fromJson(json['data'])
          : null,
    );
  }
}

class PresignUploadData {
  final String key;
  final String url;
  final String expiresAt;

  PresignUploadData({
    required this.key,
    required this.url,
    required this.expiresAt,
  });

  factory PresignUploadData.fromJson(Map json) {
    return PresignUploadData(
      key: json['key'],
      url: json['url'],
      expiresAt: json['expiresAt'],
    );
  }
}