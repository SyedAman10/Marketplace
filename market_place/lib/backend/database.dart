import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:market_place/models/service_provider.dart';
import 'package:market_place/models/user.dart';
import 'authenticate.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Status> addUser(uid, email, displayName) async {
    /// This adds a new user to the database.
    /// Call the Authenticate().signup(...) to get the uid.
    /// It returns the Status.success if user is added and returns Status.unknownError if
    /// something goes wrong.

    User user = User.createNew(uid, email, displayName);

    try {
      await _firestore.collection("Users").doc(uid).set(user.toMap());
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Status> addServiceProvider(uid, email, displayName) async {
    /// This adds a new service-provider to the database.
    /// Call the Authenticate().signup(...) to get the uid.
    /// It returns Status.success if service-provider is added and returns
    /// Status.unknownError if something goes wrong.

    ServiceProvider serviceProvider =
        ServiceProvider.createNew(uid, email, displayName);

    try {
      await _firestore
          .collection("ServiceProviders")
          .doc(uid)
          .set(serviceProvider.toMap());
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
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
    /// Returns Status.success if deleted else returns Status.unknownError
    /// and prints error to console.

    try {
      await _firestore.collection("ServiceProviders").doc(uid).delete();
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Stream<Object>?> getAccountDataStream(uid) async {
    /// Returns a stream of the account.
    /// Returns either a User or ServiceProvider STREAM or null if something goes wrong.

    try {
      var userData = await _firestore.collection("Users").doc(uid).snapshots();

      if (await userData.isEmpty) {
        var spData =
            _firestore.collection("ServiceProviders").doc(uid).snapshots();
        return spData
            .map((event) => ServiceProvider.fromMap(event.data() as Map));
      } else {
        return userData.map((event) => User.fromMap(event.data() as Map));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Object?> getCurrentAccountDataOnce(uid) async {
    /// Returns the user's data at the time of calling this function.
    /// Returns either a User or ServiceProvider object or null if something goes wrong.

    try {
      var docData = await _firestore.collection("Users").doc(uid).get();

      if (docData.exists) {
        return User.fromMap(docData.data() as Map);
      } else {
        docData =
            await _firestore.collection("ServiceProviders").doc(uid).get();
        return ServiceProvider.fromMap(docData.data() as Map);
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
