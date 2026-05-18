sealed class ChatRoomBackResult {
  final bool success;

  ChatRoomBackResult({required this.success});
}

class ChatRoomReadResult extends ChatRoomBackResult {
  ChatRoomReadResult({required super.success});
}

class ChatRoomQuitResult extends ChatRoomBackResult {
  ChatRoomQuitResult({required super.success});
}
