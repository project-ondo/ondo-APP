import 'dart:convert';

import 'package:http/http.dart';
import 'package:ondo/data/models/report/request/report_request_model.dart';
import 'package:ondo/data/network/constants/api_constants.dart';

class ReportRemoteDatasource {
  final BaseClient _client;

  ReportRemoteDatasource(this._client);

  Future<bool> report(ReportRequestModel model) async {
    final log = ApiConstants(logName: '신고 접수 서버');

    try {
      final res = await _client.post(
        Uri.parse(ApiConstants.report),
        headers: ApiConstants.baseHeader,
        body: jsonEncode(model.toJson()),
      );

      final body = jsonDecode(res.body);

      log.successLog(body['success']);
      log.messageLog(body['message']);

      if (res.statusCode == 200 && body['success'] == true) {
        return true;
      }
      log.statusLog(res.statusCode);
    } catch (e) {
      log.errorLog(e);
    }

    return false;
  }
}
