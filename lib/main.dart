import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ondo/core/design_system/app_colors.dart';
import 'package:ondo/core/design_system/app_theme.dart';
import 'package:ondo/core/design_system/component_variants.dart';
import 'package:ondo/core/design_system/components/custom_button.dart';

import 'core/design_system/components/custom_textfield.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This components is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.appTheme(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  TextEditingController test0 = TextEditingController();
  TextEditingController test1 = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 30),
              CustomTextField(
                label: '테스트',
                hintText: '테스트입니다.',
                keyboardType: TextInputType.text,
                errorText: '에러 테스트입니다!!',
                hasError: false,
                controller: test0,
                variant: TextFieldVariant.normal,
              ),
              CustomButton(
                text: '테스트',
                variant: ButtonVariant.primary,
                onPressed: () {
                  log(test0.text);
                },
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                label: '비밀번호',
                hintText: '비밀번호를 입력해주세요.',
                keyboardType: TextInputType.visiblePassword,
                errorText: '비밀번호가 달라요. 비밀번호를 다시 한번 확인해주세요!',
                hasError: true,
                controller: test1,
                variant: TextFieldVariant.password,
              ),
              Row(
                children: [
                  CustomButton(
                    text: '테스트1',
                    variant: ButtonVariant.outline,
                    onPressed: () {
                      log(test1.text);
                    },
                  ),CustomButton(
                    text: '테스트1',
                    variant: ButtonVariant.select,
                    onPressed: () {
                      log(test1.text);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
