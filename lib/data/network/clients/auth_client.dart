import 'package:http/http.dart';
import 'package:ondo/data/datasource/base/auth_local_datasource.dart';

class AuthClient extends BaseClient {
  AuthLocalDatasource datasource;

  AuthClient({required this.datasource});

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final token = await datasource.getAccessToken();
    if (token != null) {
      request.headers["Authorization"] = "Bearer $token";
    }
    return request.send();
  }
}
