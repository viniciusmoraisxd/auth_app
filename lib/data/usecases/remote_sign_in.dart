import 'package:auth_app/domain/usecases/sign_in.dart';

import '../../domain/helpers/helpers.dart';
import '../firebase/firebase.dart';

class RemoteSignIn implements SignIn{
  final FirebaseAuthClient firebaseAuthClient;

  RemoteSignIn({required this.firebaseAuthClient});

  @override
  Future<void> signin({required String email, required String password}) async {
    try {
      await firebaseAuthClient.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthError catch (e) {
      switch (e) {
        case FirebaseAuthError.userDisabled:
          throw DomainError.userDisabled;
        case FirebaseAuthError.userNotFound:
          throw DomainError.userNotFound;
        case FirebaseAuthError.invalidEmail:
          throw DomainError.invalidCredentials;
        case FirebaseAuthError.wrongPassword:
          throw DomainError.invalidCredentials;
      }
    }
  }
}
