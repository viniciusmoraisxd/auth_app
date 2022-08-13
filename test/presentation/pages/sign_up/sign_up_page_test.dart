import 'package:auth_app/domain/helpers/helpers.dart';
import 'package:auth_app/presentation/controllers/controllers.dart';
import 'package:auth_app/presentation/pages/pages.dart';
import 'package:auth_app/route_generator.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../mocks/mocks.dart';

void main() {
  late SignInSpy signInSpy;
  late SignUpSpy signUpSpy;
  late SignInController signInController;
  late SignUpController signUpController;
  late String name;
  late String email;
  late String password;

  setUp(() {
    signInSpy = SignInSpy();
    signUpSpy = SignUpSpy();
    signInController = SignInController(signIn: signInSpy);
    signUpController = SignUpController(signUp: signUpSpy);

    name = faker.person.name();
    email = faker.internet.email();
    password = faker.internet.password();

    signUpSpy.mockSignUpResponse();
  });

  loadPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => signUpController),
        ChangeNotifierProvider(create: (context) => signInController),
      ],
      child: const MaterialApp(
        initialRoute: '/sign_up',
        home: SignUpPage(),
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  testWidgets('Should display widgets correctly', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    expect(find.byKey(const Key("signUpAsset")), findsOneWidget);

    expect(find.text('Registre-se'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Seu nome completo'),
        findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Seu e-mail'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Sua senha'), findsOneWidget);
    expect(
        find.widgetWithText(TextFormField, 'Repita sua senha'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Registrar'), findsOneWidget);
    expect(find.byKey(const Key("Logar")), findsOneWidget);
  });

  testWidgets('Should not present ErrorMessage if Form is valid',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('Campo obrigatório'), findsNothing);
    expect(find.text('E-mail inválido'), findsNothing);
  });

  testWidgets('Should present RequiredField if TextFormFields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), '');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), '');
    await tester.enterText(find.widgetWithText(TextFormField, 'Sua senha'), '');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), '');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsNWidgets(4));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), 'invalid_email');
    await tester.pump();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });

  testWidgets('Should present error if confirmation password is invalid',
      (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), 'any_password');
    await tester.pump();

    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('Should call signIn on form submit', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    verify(() => signUpSpy(email: email, password: password)).called(1);
  });

  testWidgets('Should handle loading correctly', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  // testWidgets('Should go to signIn page', (WidgetTester tester) async {
  //   await tester.pumpWidget(loadPage());
  //   await tester.tap(find.byKey(const Key("signInButton")));
  //   await tester.pumpAndSettle(const Duration(seconds: 1));

  //   expect(find.byType(SignUpPage), findsNothing);
  //   expect(find.byType(SignInPage), findsOneWidget);
  // });

  testWidgets('Should present EmailInUseError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signUpSpy.mockSignUpResponseError(DomainError.emailInUse);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));

    expect(find.text("O e-mail já está em uso."), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); //começa a animação
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("O e-mail já está em uso."), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("O e-mail já está em uso."), findsNothing);
  });

  testWidgets('Should present InvalidEmailError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signUpSpy.mockSignUpResponseError(DomainError.invalidEmail);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));

    expect(find.text("Campo inválido."), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); //começa a animação
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Campo inválido."), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("Campo inválido."), findsNothing);
  });

  testWidgets('Should present userDisabledError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signUpSpy.mockSignUpResponseError(DomainError.userDisabled);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));

    expect(find.text("Este usuário está desabilitado."), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); //começa a animação
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Este usuário está desabilitado."), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("Este usuário está desabilitado."), findsNothing);
  });

  testWidgets('Should present weakPasswordError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signUpSpy.mockSignUpResponseError(DomainError.weakPassword);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));

    expect(find.text("Senha fraca."), findsNothing);

    await tester.pump(const Duration(milliseconds: 500)); //começa a animação
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text("Senha fraca."), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text("Senha fraca."), findsNothing);
  });

  testWidgets('Should present UnexpectedError', (WidgetTester tester) async {
    await tester.pumpWidget(loadPage());

    signUpSpy.mockSignUpResponseError(DomainError.unexpected);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu nome completo'), name);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Seu e-mail'), email);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Sua senha'), password);

    await tester.enterText(
        find.widgetWithText(TextFormField, 'Repita sua senha'), password);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Registrar'));

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
