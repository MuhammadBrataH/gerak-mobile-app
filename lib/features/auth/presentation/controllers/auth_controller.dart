import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    final List<UserModel> _dummyusers = [
      UserModel(
        nama: 'Muhammad Brata Hadinata',
        email: 'muhammadbrata06@gmail.com',
        password: 'password',
        skill: 'Jago',
      ),
      UserModel(
        nama: 'Ersya Hasby',
        email: 'ersya.hasby@gmail.com',
        password: 'password',
        skill: 'Poke',
      ),
      UserModel(
        nama: 'Varian Abidarma',
        email: 'varian.abidarma@gmail.com',
        password: 'password',
        skill: 'Bau',
      ),
      UserModel(nama: 'Admin', email: 'admin', password: '123', skill: 'Baq'),
    ];

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Login Failed', 'Email and password cannot be empty');
      return;
    }

    isLoading.value = true;
    // Simulate a login process
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;

    try {
      final user = _dummyusers.firstWhere(
        (user) => user.email == email && user.password == password,
      );
      Get.snackbar('Login', 'Login successful. Welcome, ${user.nama}!');
      Get.offAllNamed(
        AppRoutes.dashboard,
      ); // Navigate to dashboard page after successful login
    } catch (e) {
      Get.snackbar('Login Failed', 'Invalid email or password');
    }
  }

  void logout() {
    Get.snackbar('Logout', 'You have been logged out');
    Get.offAllNamed(AppRoutes.login); // Navigate back to login page on logout
  }
}
