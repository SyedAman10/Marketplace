import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  operationNotAllowed,
  userDisabled,
  userNotFound,
  incorrectPassword,
  unknownError,
  success,
}

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Object> signup(String email, String password) async {
    /// Tries to sign up user AND log them in.
    /// Returns its uid if it was a success else returns a Status defining
    /// the problem that occured.
    /// This function DOES NOT add the account on the cloud firestore.
    /// It has to be done manually by Database().addUser(...) or
    /// Database().addServiceProvider(...).

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      String code = e.code;

      if (code == "email-already-in-use") {
        return Status.emailAlreadyInUse;
      } else if (code == 'invalid-email') {
        return Status.invalidEmail;
      } else if (code == 'weak-password') {
        return Status.weakPassword;
      } else if (code == 'operation-not-allowed') {
        print(e.toString());
        return Status.unknownError;
      }
      return Status.unknownError;
    }
  }

  Future<Status> deleteAccount(email) async {
    /// This tries to delete the currently logged in account.
    /// It return Status.success if the account gets deleted and
    /// returns Status.unknownError if something goes wrong and
    /// print the error to the console.

    try {
      await _auth.currentUser?.delete();
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }
}
