import 'package:ondo/data/models/base/request/base_list_request_model.dart';

class ChatMessageListRequestModel extends BaseListRequestModel {
  final int cursor;

  ChatMessageListRequestModel({required super.size, required this.cursor})
    : super(start: cursor);

  @override
  String toQueryParameter() => "?size=$size&cursor=$cursor";
}
