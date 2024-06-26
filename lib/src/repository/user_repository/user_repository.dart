import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:login_app/src/features/auth/model/user_model.dart';
import 'package:login_app/src/repository/auth_repository/auth_repo.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    try {
      await _db.collection("Users").add(user.toJson());
    } catch (e) {
      Get.snackbar("Error", "Could not create user!");
    }
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("Email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await _db
        .collection("Users")
        .orderBy("Timestamp", descending: true)
        .get();
    final userData =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return userData;
  }

  Future<void> updateUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
      Get.snackbar("Success", "Record updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      // Delete user from Firebase Authentication
      await _authRepo.deleteUserAccount();
      // Get all contacts of the user
      QuerySnapshot contactsSnapshot = await _db
          .collection('Contacts')
          .where('UserId', isEqualTo: user.id)
          .get();

      // Delete each contact document
      for (QueryDocumentSnapshot doc in contactsSnapshot.docs) {
        await doc.reference.delete();
      }
      // Delete user's document from Firestore collection
      await _db.collection('Users').doc(user.id).delete();
      Get.snackbar("Success", "Record deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
      // ignore: avoid_print
      print("Delete User : ${e.toString()}");
    }
  }

  Future<void> deleteOtherUser(UserModel user) async {
    try {
      // Get all contacts of the user
      QuerySnapshot contactsSnapshot = await _db
          .collection('Contacts')
          .where('UserId', isEqualTo: user.id)
          .get();

      // Delete each contact document
      for (QueryDocumentSnapshot doc in contactsSnapshot.docs) {
        await doc.reference.delete();
      }
      // Delete user's document from Firestore collection
      await _db.collection('Users').doc(user.id).delete();
      Get.snackbar("Success", "Record deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!");
      // ignore: avoid_print
      print("Delete User : ${e.toString()}");
    }
  }
}
