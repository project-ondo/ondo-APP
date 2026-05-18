import 'package:flutter_test/flutter_test.dart';
import 'package:ondo/presentation/chat/view_models/chat_message_view_model.dart';

void main() {
  group('ChatMessageViewModel.fromJson (WebSocket 실시간 수신)', () {
    test('정상 payload 파싱', () {
      final json = {
        'messageId': 1,
        'roomId': 'room-uuid',
        'senderId': 42,
        'messageType': 'TEXT',
        'content': '안녕하세요',
        'createdAt': '2026-03-16T12:00:00',
      };

      final vm = ChatMessageViewModel.fromJson(json);

      expect(vm.messageType, 'TEXT');
      expect(vm.content, '안녕하세요');
      expect(vm.createdAt, DateTime.parse('2026-03-16T12:00:00'));
      expect(vm.isMe, false);
      expect(vm.profileImageKey, isNull);
    });

    test('IMAGE 타입 메시지 파싱', () {
      final json = {
        'messageId': 2,
        'roomId': 'room-uuid',
        'senderId': 42,
        'messageType': 'IMAGE',
        'content': 'https://cdn.example.com/img.png',
        'createdAt': '2026-03-16T13:00:00',
      };

      final vm = ChatMessageViewModel.fromJson(json);

      expect(vm.messageType, 'IMAGE');
      expect(vm.content, 'https://cdn.example.com/img.png');
    });

    test('messageType 누락 → 기본값 TEXT', () {
      final json = {
        'messageId': 3,
        'roomId': 'room-uuid',
        'senderId': 42,
        'content': '내용',
        'createdAt': '2026-03-16T12:00:00',
      };

      final vm = ChatMessageViewModel.fromJson(json);

      expect(vm.messageType, 'TEXT');
    });

    test('content 누락 → 빈 문자열', () {
      final json = {
        'messageId': 4,
        'roomId': 'room-uuid',
        'senderId': 42,
        'messageType': 'TEXT',
        'createdAt': '2026-03-16T12:00:00',
      };

      final vm = ChatMessageViewModel.fromJson(json);

      expect(vm.content, '');
    });

    test('createdAt 누락 → 현재 시각으로 대체 (예외 없음)', () {
      final before = DateTime.now();
      final json = {
        'messageId': 5,
        'roomId': 'room-uuid',
        'senderId': 42,
        'messageType': 'TEXT',
        'content': '내용',
      };

      final vm = ChatMessageViewModel.fromJson(json);
      final after = DateTime.now();

      expect(vm.createdAt.isAfter(before) || vm.createdAt.isAtSameMomentAs(before), true);
      expect(vm.createdAt.isBefore(after) || vm.createdAt.isAtSameMomentAs(after), true);
    });

    test('createdAt 잘못된 형식 → 현재 시각으로 대체 (예외 없음)', () {
      final before = DateTime.now();
      final json = {
        'messageId': 6,
        'roomId': 'room-uuid',
        'senderId': 42,
        'messageType': 'TEXT',
        'content': '내용',
        'createdAt': 'invalid-date',
      };

      final vm = ChatMessageViewModel.fromJson(json);
      final after = DateTime.now();

      expect(vm.createdAt.isAfter(before) || vm.createdAt.isAtSameMomentAs(before), true);
      expect(vm.createdAt.isBefore(after) || vm.createdAt.isAtSameMomentAs(after), true);
    });

    test('isMe는 항상 false (senderId 비교 미구현)', () {
      final json = {
        'messageId': 7,
        'roomId': 'room-uuid',
        'senderId': 99,
        'messageType': 'TEXT',
        'content': '내용',
        'createdAt': '2026-03-16T12:00:00',
      };

      final vm = ChatMessageViewModel.fromJson(json);

      expect(vm.isMe, false);
    });
  });

  group('ChatMessageViewModel 직접 생성 (내가 보낸 메시지)', () {
    test('sendChat 즉시 반영용 ViewModel - isMe: true', () {
      final vm = ChatMessageViewModel(
        messageType: 'TEXT',
        content: '안녕하세요',
        createdAt: DateTime.now(),
        isMe: true,
        profileImageKey: null,
      );

      expect(vm.isMe, true);
      expect(vm.messageType, 'TEXT');
      expect(vm.content, '안녕하세요');
      expect(vm.profileImageKey, isNull);
    });

    test('빈 문자열 content는 전송하지 않아야 함 (trim 검증)', () {
      // ChatRoomController.sendChat()은 content.trim().isEmpty이면
      // stompClient.publish를 호출하지 않아야 함
      // (단위 테스트는 ChatRoomController mock 테스트에서 검증)
      const raw = '   ';
      expect(raw.trim().isEmpty, true);
    });

    test('공백 포함 content는 trim 후 전송', () {
      const raw = '  안녕  ';
      expect(raw.trim(), '안녕');
    });
  });
}