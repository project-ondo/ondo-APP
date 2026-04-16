import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ondo/data/models/media/request/presign_upload_request_model.dart';
import 'package:ondo/data/models/media/response/presign_upload_response_model.dart';
import 'package:ondo/data/network/clients/auth_client.dart';
import 'package:ondo/data/network/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class MediaRemoteDatasource {
  final AuthClient client;

  MediaRemoteDatasource({required this.client});

  /// 1단계: presign URL 발급
  Future<PresignUploadData> getPresignUrl({
    required String category,
    required String contentType,
  }) async {
    final log = ApiConstants(logName: '이미지 presign URL 발급');

    final model = PresignUploadRequestModel(
      category: category,
      contentType: contentType,
    );

    final res = await client.post(
      Uri.parse('${ApiConstants.domain}/media/presign/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    final body = jsonDecode(res.body);
    log.successLog(body['success'] ?? false);
    log.messageLog(body['message'] ?? '');

    if (res.statusCode != 200 || body['success'] != true) {
      log.statusLog(res.statusCode);
      throw Exception('presign URL 발급 실패: ${body['message']}');
    }

    final responseModel = PresignUploadResponseModel.fromJson(body);

    if (responseModel.data == null) {
      throw Exception('presign URL 데이터가 없습니다.');
    }

    return responseModel.data!;
  }

  /// 2단계: S3에 이미지 업로드 (binary PUT)
  Future<void> uploadImageToS3({
    required String presignUrl,
    required String imagePath,
    required String contentType,
  }) async {
    final log = ApiConstants(logName: 'S3 이미지 업로드');

    final file = File(imagePath);
    final bytes = await file.readAsBytes();

    // S3 presign URL은 인증 헤더 없이 직접 PUT
    final res = await http.put(
      Uri.parse(presignUrl),
      headers: {'Content-Type': contentType},
      body: bytes,
    );

    log.statusLog(res.statusCode);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('S3 이미지 업로드 실패: ${res.statusCode}');
    }

    if (kDebugMode) debugPrint('[S3 업로드 완료]');
  }

  /// presign 발급 + S3 업로드 한 번에 처리 → key 반환
  Future<String> uploadImage({
    required String imagePath,
    String category = 'PROFILE',
  }) async {
    // 확장자로 contentType 결정
    final ext = imagePath.split('.').last.toLowerCase();
    final contentType = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };

    final presignData = await getPresignUrl(
      category: category,
      contentType: contentType,
    );

    await uploadImageToS3(
      presignUrl: presignData.url,
      imagePath: imagePath,
      contentType: contentType,
    );

    return presignData.key;
  }
}