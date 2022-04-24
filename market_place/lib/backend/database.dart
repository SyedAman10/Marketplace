import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:market_place/models/service_provider.dart';
import 'package:market_place/models/user.dart';
import 'authenticate.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addUser(email, displayName) async {
    /// This adds a new user to the database.
    /// It returns the uid of the user and returns null if
    /// something goes wrong.

    User user = User.createNew(email, displayName);

    try {
      return _firestore
          .collection("Users")
          .add(user.toMap() as Map<String, dynamic>)
          .then((value) => value.id);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> addServiceProvider(email, displayName) async {
    /// This adds a new service-provider to the database.
    /// It returns the uid of the user and returns null if
    /// something goes wrong.

    ServiceProvider serviceProvider =
        ServiceProvider.createNew(email, displayName);

    try {
      return _firestore
          .collection("ServiceProviders")
          .add(serviceProvider.toMap() as Map<String, dynamic>)
          .then((value) => value.id);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Status> deleteUser(String uid) async {
    /// This only deletes a user from the cloud firestore.
    /// In order to remove its authentication (allow a new account to be created with this email again)
    /// delete its authentication by Authenticate().deleteAccount("email") .
    /// Returns Status.success if deleted else returns Status.unknown error
    /// and prints error to console.

    try {
      await _firestore.collection("Users").doc(uid).delete();
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Status> deleteServiceProvider(String uid) async {
    /// This only deletes a service-provider from the cloud firestore.
    /// In order to remove its authentication (allow a new account to be created with this email again)
    /// delete its authentication by Authenticate().deleteAccount("email") .
    /// Returns Status.success if deleted else returns Status.unknown error
    /// and prints error to console.

    try {
      await _firestore.collection("ServiceProviders").doc(uid).delete();
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }
}
