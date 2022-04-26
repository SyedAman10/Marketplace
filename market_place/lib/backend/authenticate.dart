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

  Future<Status> deleteAccount() async {
    /// This tries to ONLY delete the currently logged in account.
    /// It does not delete it from the cloud firestore which can be done by
    /// Database().deleteAccount("uid").
    ///
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

  Future<Status> login(email, password) async {
    /// This logins the user with email and password.
    /// Returns Status.success if the login was successful
    /// else returns a Status defining the problem the occured.

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return Status.success;
    } on FirebaseAuthException catch (e) {
      final String code = e.code;

      if (code == 'invalid-email') {
        return Status.invalidEmail;
      } else if (code == 'user-disabled') {
        return Status.userDisabled;
      } else if (code == 'user-not-found') {
        return Status.userNotFound;
      } else if (code == 'wrong-password') {
        return Status.incorrectPassword;
      } else {
        print(e.toString());
        return Status.unknownError;
      }
    }
  }

  Future<Status> sendResetPasswordMail(email) async {
    /// Sends a password reset email incase a user forgets their password.

    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Status> logout() async {
    /// Returns Status.success if the account got logged out
    /// else returns Status.unknownError

    try {
      await _auth.signOut();
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  String get getCurrentUserUid {
    return _auth.currentUser!.uid;
  }
}
