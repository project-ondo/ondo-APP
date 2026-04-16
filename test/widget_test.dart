import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ondo/main.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';
import 'package:ondo/core/design_system/components/custom_textfield.dart';
import 'package:ondo/core/design_system/component_variants.dart';

void main() {
  // 테스트마다 GetX 상태를 완전히 초기화합니다.
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });
  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  group('ONDO App Widget Tests', () {
    // 1. CustomButton 테스트
    testWidgets('CustomButton tap triggers onPressed', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            variant: ButtonVariant.primary,
            onPressed: () => tapped = true,
          ),
        ),
      ));
      await tester.tap(find.text('Test Button'));
      await tester.pump();
      expect(tapped, true);
    });

    // 2. CustomTextField 테스트
    testWidgets('CustomTextField accepts input', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CustomTextField(controller: controller, hintText: '테스트'),
        ),
      ));
      await tester.enterText(find.byType(TextFormField), 'Eunseo');
      await tester.pump();
      expect(controller.text, 'Eunseo');
    });

    // 3. 메인 앱 렌더링 테스트
    testWidgets('Main app renders without crashing', (WidgetTester tester) async {
      // 앱을 빌드합니다.
      await tester.pumpWidget(const MyApp());

      // [핵심 수정] runAsync 대신 가상 시간을 직접 2초 흐르게 합니다.
      // SplashController의 1.5초 타이머를 만료시키기 위함입니다.
      await tester.pump(const Duration(milliseconds: 2000));

      // 타이머 만료 후 발생하는 모든 애니메이션이 끝날 때까지 대기합니다.
      await tester.pumpAndSettle();

      // 위젯이 잘 렌더링 되었는지 확인합니다.
      expect(find.byType(MyApp), findsOneWidget);
    });
  });
}