import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ondo/main.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/design_system/component_variants.dart';

void main() {
  /// 각 테스트가 종료될 때마다 실행됩니다.
  /// GetX 컨트롤러와 타이머 잔류물을 깨끗하게 지워 CI 에러를 방지합니다.
  tearDown(() {
    Get.reset();
  });

  group('ONDO App Widget Tests', () {
    testWidgets('CustomButton tap triggers onPressed', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              variant: ButtonVariant.primary,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      // 버튼이 화면에 있는지 확인
      expect(find.text('Test Button'), findsOneWidget);

      // 버튼 탭
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // onPressed 실행 확인
      expect(tapped, true);
    });

    testWidgets('CustomTextField accepts input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              controller: controller,
              hintText: '테스트',
            ),
          ),
        ),
      );

      // TextField 찾기
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      // 입력 테스트
      await tester.enterText(textField, 'Eunseo');
      await tester.pump();

      // 입력 값 확인
      expect(controller.text, 'Eunseo');
      expect(find.text('Eunseo'), findsOneWidget);
    });

    testWidgets('Main app renders without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());

      // SplashController의 Future.delayed(1500ms)를 CI 환경에서 확실히 처리하기 위해
      // runAsync 내부에서 실제 비동기 대기를 수행합니다.
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 1600));
      });

      // 타이머 완료 후 발생하는 모든 애니메이션과 프레임 변화를 끝까지 처리합니다.
      await tester.pumpAndSettle();

      // MyApp 내 위젯 존재 여부 간단 체크
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
