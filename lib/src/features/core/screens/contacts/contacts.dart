import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_app/src/common/bottom_navbar.dart';
import 'package:login_app/src/common/side_drawer.dart';
import 'package:login_app/src/features/auth/model/user_model.dart';
import 'package:login_app/src/features/core/screens/contacts/new_contact.dart';
import 'package:login_app/src/features/core/screens/profile/profile_screen.dart';
import 'package:login_app/src/repository/auth_repository/auth_repo.dart';
import 'package:login_app/src/repository/user_repository/user_repository.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final controller = Get.put(UserRepository());
  final _authRepo = Get.put(AuthRepository());
  // ignore: unused_field
  late final UserModel _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final email = _authRepo.firebaseUser.value?.email;
    if (email != null) {
      final userData = await controller.getUserDetails(email);
      setState(() {
        _user = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text(
          "CONTACTS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const ProfileScreen()),
            icon: const Icon(
              Icons.person_outline,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: const SideDrawer(),
      bottomNavigationBar: const MyBottonNavbar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () => Get.to(() => const NewContactScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}