import 'package:auth_app/data/usecases/usecases.dart';
import 'package:auth_app/presentation/controllers/sign_in/sign_in.dart';
import 'package:auth_app/presentation/controllers/sign_up/sign_up.dart';
import 'package:auth_app/route_generator.dart';
import 'package:auth_app/shared/themes/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'infra/firebase/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      providers: [
        Provider(
            create: (_) =>
                FirebaseAuthAdapter(firebaseAuth: FirebaseAuth.instance)),
        Provider(
            create: (context) => RemoteSignIn(
                firebaseAuthClient: context.read<FirebaseAuthAdapter>())),
        ChangeNotifierProvider(
            create: (context) =>
                SignInController(signIn: context.read<RemoteSignIn>())),
        Provider(
            create: (context) => RemoteSignUp(
                firebaseAuthClient: context.read<FirebaseAuthAdapter>())),
        ChangeNotifierProvider(
            create: (context) =>
                SignUpController(signUp: context.read<RemoteSignUp>()))
      ],
      child: OverlaySupport.global(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Auth Demo',
          initialRoute: "/login",
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
