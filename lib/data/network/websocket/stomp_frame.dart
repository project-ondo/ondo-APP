/// STOMP 프레임 직렬화 / 역직렬화 유틸리티
///
/// STOMP 프레임 포맷:
/// ```
/// COMMAND\n
/// header1:value1\n
/// header2:value2\n
/// \n
/// body\0
/// ```
class StompFrame {
  final String command;
  final Map<String, String> headers;
  final String? body;

  const StompFrame({
    required this.command,
    this.headers = const {},
    this.body,
  });

  /// 프레임 → String (서버로 전송)
  String serialize() {
    final buffer = StringBuffer();
    buffer.write('$command\n');
    for (final entry in headers.entries) {
      buffer.write('${entry.key}:${entry.value}\n');
    }
    buffer.write('\n');
    if (body != null) {
      buffer.write(body);
    }
    buffer.write('\x00');
    return buffer.toString();
  }

  /// String → StompFrame (서버에서 수신)
  static StompFrame? parse(String raw) {
    // 빈 heartbeat 프레임 무시
    if (raw.isEmpty || raw == '\n' || raw == '\x00') return null;

    // 헤더 섹션과 바디 섹션을 \n\n 기준으로 분리
    final headerBodySplit = raw.split('\n\n');
    if (headerBodySplit.isEmpty) return null;

    final headerSection = headerBodySplit[0];

    // 바디: \n\n 이후 전체, null terminator 제거
    String? body;
    if (headerBodySplit.length > 1) {
      final rawBody = headerBodySplit.sublist(1).join('\n\n').replaceAll('\x00', '').trim();
      body = rawBody.isEmpty ? null : rawBody;
    }

    final lines = headerSection.split('\n');
    if (lines.isEmpty) return null;

    final command = lines[0].trim();
    if (command.isEmpty) return null;

    final headers = <String, String>{};
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final colonIndex = line.indexOf(':');
      if (colonIndex == -1) continue;
      headers[line.substring(0, colonIndex).trim()] =
          line.substring(colonIndex + 1).trim();
    }

    return StompFrame(command: command, headers: headers, body: body);
  }

  @override
  String toString() => 'StompFrame(command: $command, headers: $headers)';
}
