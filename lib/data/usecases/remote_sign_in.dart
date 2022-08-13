import 'package:auth_app/domain/usecases/sign_in.dart';

import '../../domain/helpers/helpers.dart';
import '../firebase/firebase.dart';

class RemoteSignIn implements SignIn{
  final FirebaseAuthClient firebaseAuthClient;

  RemoteSignIn({required this.firebaseAuthClient});

  @override
  Future<void> call({required String email, required String password}) async {
    try {
      await firebaseAuthClient.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseSignInError catch (e) {
      switch (e) {
        case FirebaseSignInError.userDisabled:
          throw DomainError.userDisabled;
        case FirebaseSignInError.userNotFound:
          throw DomainError.userNotFound;
        case FirebaseSignInError.invalidEmail:
          throw DomainError.invalidCredentials;
        case FirebaseSignInError.wrongPassword:
          throw DomainError.invalidCredentials;
      }
    }
  }
}
