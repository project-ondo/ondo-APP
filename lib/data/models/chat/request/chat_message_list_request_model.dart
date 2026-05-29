import 'package:ondo/data/models/base/request/base_list_request_model.dart';

class ChatMessageListRequestModel extends BaseListRequestModel {
  final int cursor;

  ChatMessageListRequestModel({required super.size, required this.cursor})
    : super(start: cursor);

  @override
  // cursor=0은 초기 요청 — 서버가 최신 메시지부터 반환하도록 cursor 파라미터 생략
  String toQueryParameter() =>
      cursor == 0 ? "?size=$size" : "?size=$size&cursor=$cursor";
}
