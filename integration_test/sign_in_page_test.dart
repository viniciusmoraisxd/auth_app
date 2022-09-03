import 'package:auth_app/firebase_options.dart';
import 'package:auth_app/presentation/pages/pages.dart';
import 'package:faker/faker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:auth_app/main.dart';

Future<void> addDelay(int seconds) async {
  await Future<void>.delayed(Duration(seconds: seconds));
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  late String email;
  late String password;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    email = "test@email.com";
    password = '123456';
  });

  group('end-to-end test', () {
    testWidgets('Try SignIn with valid credentials', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));

      await tester.pumpAndSettle();

      expect(find.text('Logado'), findsOneWidget);
      expect(find.byType(SignInPage), findsNothing);
    });

    testWidgets('Try SignIn with invalid credentials', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), email);
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), 'invalid_password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle();

      expect(find.text("Credenciais inválidas"), findsOneWidget);
    });

    testWidgets('Try SignIn with invalid user', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'E-mail'), faker.internet.email());
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Senha'), password);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Entrar'));
      await tester.pumpAndSettle();

      expect(find.text("Usuário não encontrado"), findsOneWidget);
    });
  });
}
