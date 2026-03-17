import 'package:get/get.dart';

class SearchState {
  Set<String> tags = <String>{};
  String query = "";

  void clear() {
    tags.clear();
    query = "";
  }
}
