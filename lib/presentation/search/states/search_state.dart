import 'package:get/get.dart';

class SearchState {
  final RxList<String> tags = <String>[].obs;
  final RxString query = "".obs;
}
