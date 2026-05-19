import 'package:flutter_test/flutter_test.dart';
import 'package:ondo/data/network/websocket/stomp_frame.dart';

void main() {
  group('StompFrame 직렬화 (serialize)', () {
    test('CONNECT 프레임 - 헤더와 null terminator 포함', () {
      final frame = StompFrame(
        command: 'CONNECT',
        headers: {
          'accept-version': '1.1,1.2',
          'Authorization': 'Bearer token123',
        },
      );
      final result = frame.serialize();

      expect(result, startsWith('CONNECT\n'));
      expect(result, contains('accept-version:1.1,1.2\n'));
      expect(result, contains('Authorization:Bearer token123\n'));
      expect(result, endsWith('\x00'));
    });
    test('SEND 프레임 - body 포함', () {

      final frame = StompFrame(
        command: 'SEND',
        headers: {
          'destination': '/pub/chat.send',
          'content-type': 'application/json',
        },
        body: '{"chatRoomPublicId":"uuid","messageType":"TEXT","content":"hello"}',
      );
      final result = frame.serialize();

      // 전체 구조 엄격 검증 (커맨드\n헤더\n\n바디\x00)
      expect(result, startsWith('SEND\n'));
      expect(result, contains('destination:/pub/chat.send\n'));
      expect(result, contains('content-type:application/json\n'));
      expect(result, contains('\n\n')); // 헤더-바디 구분자
      expect(result, contains('{"chatRoomPublicId":"uuid","messageType":"TEXT","content":"hello"}'));
      expect(result, endsWith('\x00'));
    });

    test('DISCONNECT 프레임 - 헤더/바디 없음', () {
      final frame = StompFrame(command: 'DISCONNECT');
      final result = frame.serialize();

      expect(result, 'DISCONNECT\n\n\x00');
    });

    test('SUBSCRIBE 프레임', () {
      final frame = StompFrame(
        command: 'SUBSCRIBE',
        headers: {
          'destination': '/topic/chat.rooms.abc',
          'id': 'sub-0',
        },
      );
      final result = frame.serialize();

      expect(result, contains('destination:/topic/chat.rooms.abc\n'));
      expect(result, contains('id:sub-0\n'));
    });
  });

  group('StompFrame 역직렬화 (parse)', () {
    test('CONNECTED 프레임 파싱', () {
      const raw = 'CONNECTED\nversion:1.1\nsession:abc\n\n\x00';
      final frame = StompFrame.parse(raw);

      expect(frame, isNotNull);
      expect(frame!.command, 'CONNECTED');
      expect(frame.headers['version'], '1.1');
      expect(frame.headers['session'], 'abc');
      expect(frame.body, isNull);
    });

    test('MESSAGE 프레임 파싱 - body 포함', () {
      const raw =
          'MESSAGE\n'
          'subscription:sub-0\n'
          'destination:/topic/chat.rooms.uuid\n'
          '\n'
          '{"messageId":1,"content":"hello"}\x00';
      final frame = StompFrame.parse(raw);

      expect(frame, isNotNull);
      expect(frame!.command, 'MESSAGE');
      expect(frame.headers['subscription'], 'sub-0');
      expect(frame.body, '{"messageId":1,"content":"hello"}');
    });

    test('ERROR 프레임 파싱', () {
      const raw = 'ERROR\nmessage:Unauthorized\n\n401\x00';
      final frame = StompFrame.parse(raw);

      expect(frame, isNotNull);
      expect(frame!.command, 'ERROR');
      expect(frame.headers['message'], 'Unauthorized');
      expect(frame.body, '401');
    });

    test('빈 문자열 → null 반환', () {
      expect(StompFrame.parse(''), isNull);
    });

    test('heartbeat(\\n) → null 반환', () {
      expect(StompFrame.parse('\n'), isNull);
    });

    test('null terminator만 있는 경우 → null 반환', () {
      expect(StompFrame.parse('\x00'), isNull);
    });
  });

  group('직렬화 → 역직렬화 왕복 테스트', () {
    test('SEND 프레임 왕복', () {
      final original = StompFrame(
        command: 'SEND',
        headers: {
          'destination': '/pub/chat.send',
          'content-type': 'application/json',
        },
        body: '{"content":"hello"}',
      );
      final parsed = StompFrame.parse(original.serialize());

      expect(parsed?.command, original.command);
      expect(parsed?.headers['destination'], original.headers['destination']);
      expect(parsed?.body, original.body);
    });

    test('CONNECT 프레임 왕복', () {
      final original = StompFrame(
        command: 'CONNECT',
        headers: {
          'accept-version': '1.1,1.2',
          'Authorization': 'Bearer token123',
        },
      );
      final parsed = StompFrame.parse(original.serialize());

      expect(parsed?.command, original.command);
      expect(parsed?.headers['Authorization'], 'Bearer token123');
      expect(parsed?.body, isNull);
    });
  });
}
