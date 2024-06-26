import 'package:get/get.dart';
import 'package:login_app/src/features/auth/model/user_model.dart';
import 'package:login_app/src/repository/auth_repository/auth_repo.dart';
import 'package:login_app/src/repository/user_repository/user_repository.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData() {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    }
  }

  getAllUsers() {
    return _userRepo.getAllUsers();
  }

  updateRecord(UserModel user) async {
    await _userRepo.updateUserRecord(user);
  }

  deleteRecord(UserModel user) async {
    await _userRepo.deleteUser(user);
  }

  deleteOtherUserAccount(UserModel user) async {
    await _userRepo.deleteOtherUser(user);
  }
}
