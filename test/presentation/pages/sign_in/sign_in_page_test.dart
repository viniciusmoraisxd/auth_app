import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/domain/usecases/sign_up.dart';
import 'package:auth_app/presentation/controllers/controllers.dart';
import 'package:auth_app/presentation/pages/pages.dart';
import 'package:auth_app/route_generator.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../mocks/mocks.dart';

class SignUpSpy extends Mock implements SignUp {}

void main() {
  late SignInSpy signInSpy;
  late SignUpSpy signUpSpy;
  late SignInController signInController;
  late SignUpController signUpController;
  late String email;
  late String password;

  setUp(() {
    signInSpy = SignInSpy();
    signUpSpy = SignUpSpy();
    signInController = SignInController(signIn: signInSpy);
    signUpController = SignUpController(signUp: signUpSpy);

    email = faker.internet.email();
    password = faker.internet.password();

    signInSpy.mockSignInResponse();
  });

  loadPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => signInController),
        ChangeNotifierProvider(create: (context) => signUpController),
      ],
      child: const MaterialApp(
        initialRoute: '/sign_in',
        home: SignInPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  testWidgets('Should display widgets correctly', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    expect(find.text('Login'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'E-mail'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.text('Esqueceu a senha?'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Logar'), findsOneWidget);
    expect(find.byKey(const Key("Registre-se")), findsOneWidget);
  });

  //Teste de validação dos campos de email e senha
  testWidgets('Should not present ErrorMessage if Form is valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Campo obrigatório'), findsNothing);
    expect(find.text('E-mail inválido'), findsNothing);
  });

  testWidgets('Should present RequiredField if TextFormFields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), '');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsNWidgets(2));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'E-mail'), 'invalid_email');
    await tester.pump();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });

  testWidgets('Should present error if email is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), "abc");
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), "");
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should present error if password is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '1234');
    await tester.enterText(find.widgetWithText(TextFormField, 'Password'), '');
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  testWidgets('Should call signIn on form submit', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    verify(() => signInSpy(email: email, password: password)).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should go to signup page', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.tap(find.byKey(const Key("signupButton")));
    await tester.pumpAndSettle();

    expect(find.byType(SignInPage), findsNothing);
    expect(find.byType(SignUpPage), findsOneWidget);
  });

  testWidgets('Should present InvalidCredentialsError',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signInSpy.mockSignInResponseError(DomainError.invalidCredentials);

    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));

    expect(find.text("Credenciais inválidas."), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); //começa a animação
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Credenciais inválidas."), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("Credenciais inválidas."), findsNothing);
  });

  testWidgets('Should present UnexpectedError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signInSpy.mockSignInResponseError(DomainError.unexpected);

    await tester.enterText(find.widgetWithText(TextFormField, 'E-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logar'));

    expect(find.text("Algo inesperado aconteceu. Tente novamente em breve!"),
        findsNothing);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Algo errado aconteceu. Tente novamente em breve!"),
        findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("Algo errado aconteceu. Tente novamente em breve!"),
        findsNothing);
  });
}
