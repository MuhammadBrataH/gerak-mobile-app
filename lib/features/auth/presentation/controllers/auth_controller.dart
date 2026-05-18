import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient;
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString signupName = RxnString();

  AuthController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  void setSignupName(String name) {
    signupName.value = name.trim();
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Login Failed', 'Email and password cannot be empty');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data ?? const <String, dynamic>{};
      final userJson = data['user'];
      final token = data['token'];
      final refreshToken = data['refreshToken'];

      if (token is String && refreshToken is String) {
        await _apiClient.setTokens(
          accessToken: token,
          refreshToken: refreshToken,
        );
      }

      if (userJson is Map<String, dynamic>) {
        user.value = UserModel.fromJson(userJson);
      }

      Get.offAllNamed(AppRoutes.dashboard);
    } on ApiException catch (error) {
      Get.snackbar('Login Failed', error.message);
    } catch (_) {
      Get.snackbar('Login Failed', 'Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      Get.snackbar('Register Failed', 'All fields are required');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        },
      );

      final data = response.data ?? const <String, dynamic>{};
      final userJson = data['user'];
      final token = data['token'];
      final refreshToken = data['refreshToken'];

      if (token is String && refreshToken is String) {
        await _apiClient.setTokens(
          accessToken: token,
          refreshToken: refreshToken,
        );
      }

      if (userJson is Map<String, dynamic>) {
        user.value = UserModel.fromJson(userJson);
      }

      Get.snackbar('Register', 'Registration successful');
      Get.offAllNamed(AppRoutes.dashboard);
    } on ApiException catch (error) {
      Get.snackbar('Register Failed', error.message);
    } catch (_) {
      Get.snackbar('Register Failed', 'Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _apiClient.post<Map<String, dynamic>>('/auth/logout');
    } on ApiException catch (error) {
      Get.snackbar('Logout Failed', error.message);
    } catch (_) {
      Get.snackbar('Logout Failed', 'Unexpected error occurred');
    } finally {
      await _apiClient.clearTokens();
      user.value = null;
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
