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
      await _firestore
          .collection("AllAccounts")
          .doc(uid)
          .set({"email": user.email, "type": User.type});
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
      await _firestore
          .collection("AllAccounts")
          .doc(uid)
          .set({"email": serviceProvider.email, "type": ServiceProvider.type});
      return Status.success;
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Status> deleteAccount(String uid) async {
    /// This deletes an account from the cloud firestore.
    /// In order to remove its authentication (allow a new account to be created with this email again)
    /// delete its authentication by Authenticate().deleteAccount("email") .
    /// Returns Status.success if deleted else returns Status.unknown error
    /// and prints error to console.

    try {
      var data = await _firestore.collection("AllAccounts").doc(uid).get();
      if (data.get("type") == User) {
        await _firestore.collection("Users").doc(uid).delete();
        await _firestore.collection("AllAccounts").doc(uid).delete();
        return Status.success;
      } else if (data.get("type") == ServiceProvider) {
        await _firestore.collection("ServiceProviders").doc(uid).delete();
        await _firestore.collection("AllAccounts").doc(uid).delete();
        return Status.success;
      } else {
        return Status.unknownError;
      }
    } catch (e) {
      print(e);
      return Status.unknownError;
    }
  }

  Future<Stream<Object>?> getAccountDataStream(uid) async {
    /// Returns a stream of the account.
    /// Returns either a User or ServiceProvider STREAM or null if something goes wrong.

    try {
      var accountData =
          await _firestore.collection("AllAccounts").doc(uid).get();
      if (accountData.get("type") == User.type) {
        var stream = _firestore
            .collection("Users")
            .doc(uid)
            .snapshots()
            .map((event) => User.fromMap(event.data() as Map));
        return stream;
      } else if (accountData.get("type") == ServiceProvider.type) {
        var stream = _firestore
            .collection("ServiceProviders")
            .doc(uid)
            .snapshots()
            .map((event) => ServiceProvider.fromMap(event.data() as Map));
        return stream;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Object?> getAccountDataOnce(uid) async {
    /// Returns the account's data at the time of calling this function.
    /// Returns either a User or ServiceProvider object or null if something goes wrong.

    try {
      var accountData =
          await _firestore.collection("AllAccounts").doc(uid).get();
      if (accountData.get("type") == User.type) {
        var data = await _firestore.collection("Users").doc(uid).get();
        return User.fromMap(data.data() as Map);
      } else if (accountData.get("type") == ServiceProvider.type) {
        var data =
            await _firestore.collection("ServiceProviders").doc(uid).get();
        return ServiceProvider.fromMap(data.data() as Map);
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
