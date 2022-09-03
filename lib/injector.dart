import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/usecases/usecases.dart';
import 'infra/firebase/firebase.dart';
import 'presentation/controllers/controllers.dart';

class Injector {
  final BuildContext context;

  Injector({required this.context});

  List<SingleChildWidget> providers() => [
        // External frameworks
        Provider(
            create: (_) =>
                FirebaseAuthAdapter(firebaseAuth: FirebaseAuth.instance)),
        Provider(create: (_) => FirebaseDatabaseAdapter()),
        Provider(
            create: (context) => RemoteSignIn(
                firebaseAuthClient: context.read<FirebaseAuthAdapter>())),

        // Usecases
        Provider(
            create: (context) => RemoteSignUp(
                firebaseAuthClient: context.read<FirebaseAuthAdapter>())),
        Provider(
            create: (context) => RemoteAddUser(
                databaseClient: context.read<FirebaseDatabaseAdapter>())),

        // Controllers
        ChangeNotifierProvider(
            create: (context) =>
                SignInController(signIn: context.read<RemoteSignIn>())),
        ChangeNotifierProvider(
            create: (context) => SignUpController(
                signUp: context.read<RemoteSignUp>(),
                addUser: context.read<RemoteAddUser>()))
      ];
}
