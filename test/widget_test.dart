import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ondo/main.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/design_system/component_variants.dart';

void main() {
  group('ONDO App Widget Tests', () {
    testWidgets('CustomButton tap triggers onPressed', (WidgetTester tester) async {
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
              label: 'Name',
              hintText: 'Enter your name',
              controller: controller,
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

    testWidgets('Main app renders without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // MyApp 내 위젯 존재 여부 간단 체크
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}
