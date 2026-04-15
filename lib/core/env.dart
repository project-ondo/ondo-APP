import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get wsBaseUrl => dotenv.env['WS_BASE_URL'] ?? '';
  static String get loginId => dotenv.env['LOGIN_ID'] ?? '';
  static String get loginPassword => dotenv.env['LOGIN_PASSWORD'] ?? '';
}
