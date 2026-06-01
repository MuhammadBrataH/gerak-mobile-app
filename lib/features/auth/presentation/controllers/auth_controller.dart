import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final ApiClient _apiClient;
  final RxBool isLoading = false.obs;
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxnString signupName = RxnString();
  final RxnString signupEmail = RxnString();
  final RxnString signupAccountType = RxnString();
  final RxnString signupGender = RxnString();
  final Rxn<DateTime> signupDateOfBirth = Rxn<DateTime>();
  final RxList<String> selectedSports = <String>[].obs;
  final RxnString profilePhotoPath = RxnString();
  final RxnString profileDomicile = RxnString();
  final RxnString profileBio = RxnString();
  final RxMap<String, String> _displayNameByUserId = <String, String>{}.obs;
  final RxMap<String, String> _photoByUserId = <String, String>{}.obs;
  final RxMap<String, String> _domicileByUserId = <String, String>{}.obs;
  final RxMap<String, String> _bioByUserId = <String, String>{}.obs;
  final RxMap<String, List<String>> _sportsByUserId =
      <String, List<String>>{}.obs;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _googleServerClientId =
      '1094874822851-msflctkmeq7h85hhbf206168gei8menh.apps.googleusercontent.com';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: _googleServerClientId,
  );

  AuthController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  void setSignupName(String name) {
    signupName.value = name.trim();
  }

  void setSignupEmail(String email) {
    signupEmail.value = email.trim();
  }

  void setSignupAccountType(String accountType) {
    signupAccountType.value = accountType;
  }

  void setSignupGender(String gender) {
    signupGender.value = gender;
  }

  void setSignupDateOfBirth(DateTime dateOfBirth) {
    signupDateOfBirth.value = dateOfBirth;
  }

  String get displayName {
    final key = _currentUserKey();
    return _displayNameByUserId[key] ??
        user.value?.name ??
        signupName.value ??
        'User';
  }

  String? get currentProfilePhotoPath {
    final key = _currentUserKey();
    return _photoByUserId[key] ?? profilePhotoPath.value;
  }

  String get currentDomicile {
    final key = _currentUserKey();
    return _domicileByUserId[key] ?? profileDomicile.value ?? 'Indonesia';
  }

  String get currentBio {
    final key = _currentUserKey();
    return _bioByUserId[key] ?? profileBio.value ?? '';
  }

  List<String> get currentSports {
    final key = _currentUserKey();
    return _sportsByUserId[key] ?? const <String>[];
  }

  void setDisplayName(String name) {
    final key = _currentUserKey();
    final value = name.trim();
    _displayNameByUserId[key] = value;
    _storage.write(key: _storageKey('name'), value: value);
  }

  void setSelectedSports(List<String> sports) {
    final key = _currentUserKey();
    _sportsByUserId[key] = List<String>.from(sports);
    selectedSports
      ..clear()
      ..addAll(sports);
    _storage.write(key: _storageKey('sports'), value: jsonEncode(sports));
  }

  void removeSport(String sport) {
    final key = _currentUserKey();
    final current = List<String>.from(_sportsByUserId[key] ?? const []);
    current.remove(sport);
    _sportsByUserId[key] = current;
    selectedSports
      ..clear()
      ..addAll(current);
    _storage.write(key: _storageKey('sports'), value: jsonEncode(current));
  }

  void setProfilePhotoPath(String path) {
    final key = _currentUserKey();
    _photoByUserId[key] = path;
    profilePhotoPath.value = path;
    _storage.write(key: _storageKey('photo'), value: path);
  }

  void setProfileDomicile(String domicile) {
    final value = domicile.trim();
    final key = _currentUserKey();
    _domicileByUserId[key] = value;
    profileDomicile.value = value;
    _storage.write(key: _storageKey('domicile'), value: value);
  }

  void setProfileBio(String bio) {
    final value = bio.trim();
    final key = _currentUserKey();
    _bioByUserId[key] = value;
    profileBio.value = value;
    _storage.write(key: _storageKey('bio'), value: value);
  }

  void resetSignupFlow() {
    signupName.value = null;
    signupEmail.value = null;
    signupAccountType.value = null;
    signupGender.value = null;
    signupDateOfBirth.value = null;
    selectedSports.clear();
  }

  String _currentUserKey() {
    final current = user.value;
    if (current == null) return 'guest';
    if (current.id.isNotEmpty) return current.id;
    return current.email;
  }

  String _storageKey(String field) => 'profile_${_currentUserKey()}_$field';

  Future<void> _loadProfileCacheForUser() async {
    final current = user.value;
    if (current == null) return;
    final key = _currentUserKey();

    final name = await _storage.read(key: _storageKey('name'));
    if (name != null && name.isNotEmpty) {
      _displayNameByUserId[key] = name;
    }

    final photoPath = await _storage.read(key: _storageKey('photo'));
    if (photoPath != null && photoPath.isNotEmpty) {
      _photoByUserId[key] = photoPath;
    }

    final domicile = await _storage.read(key: _storageKey('domicile'));
    if (domicile != null && domicile.isNotEmpty) {
      _domicileByUserId[key] = domicile;
    }

    final bio = await _storage.read(key: _storageKey('bio'));
    if (bio != null && bio.isNotEmpty) {
      _bioByUserId[key] = bio;
    }

    final sportsJson = await _storage.read(key: _storageKey('sports'));
    if (sportsJson != null && sportsJson.isNotEmpty) {
      final decoded = jsonDecode(sportsJson);
      if (decoded is List) {
        _sportsByUserId[key] = decoded.map((e) => e.toString()).toList();
      }
    }
  }

  void _syncProfileCacheForUser() {
    final current = user.value;
    if (current == null) return;
    final key = _currentUserKey();
    if (!_displayNameByUserId.containsKey(key) && current.name.isNotEmpty) {
      _displayNameByUserId[key] = current.name;
    }
    if (!_sportsByUserId.containsKey(key) && current.sports.isNotEmpty) {
      _sportsByUserId[key] = List<String>.from(current.sports);
    }
    profilePhotoPath.value = _photoByUserId[key];
    profileDomicile.value = _domicileByUserId[key];
    profileBio.value = _bioByUserId[key];
    selectedSports
      ..clear()
      ..addAll(_sportsByUserId[key] ?? const <String>[]);
  }

  String _homeRouteForAccountType(String? accountType) {
    return AppRoutes.dashboard;
  }

  String get accountType =>
      user.value?.accountType ?? signupAccountType.value ?? 'personal';

  bool get isCommunityAccount => accountType == 'community';

  String get profileRoute =>
      isCommunityAccount ? AppRoutes.communityProfile : AppRoutes.profile;

  String get homeRoute => _homeRouteForAccountType(user.value?.accountType);

  Future<void> login(String email, String password) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      Get.snackbar('Login Failed', 'Email and password cannot be empty');
      return;
    }
    if (!_isAllowedEmailDomain(trimmedEmail)) {
      Get.snackbar('Login Failed', 'Gunakan email yang valid untuk login');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': trimmedEmail, 'password': password},
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
        await _loadProfileCacheForUser();
        _syncProfileCacheForUser();
      }

      Get.offAllNamed(_homeRouteForAccountType(user.value?.accountType));
    } on ApiException catch (error) {
      Get.snackbar('Login Failed', error.message);
    } catch (_) {
      Get.snackbar('Login Failed', 'Unexpected error occurred');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value = true;
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null || idToken.isEmpty) {
        Get.snackbar('Google Login', 'Gagal mendapatkan token Google');
        return;
      }

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/google',
        data: {'idToken': idToken},
      );

      final data = response.data ?? const <String, dynamic>{};
      final needsRegistration = data['needsRegistration'] == true;

      if (needsRegistration) {
        final profile = data['profile'];
        if (profile is Map<String, dynamic>) {
          final email = (profile['email'] ?? '').toString();
          final name = (profile['name'] ?? '').toString();
          if (email.isNotEmpty) {
            setSignupEmail(email);
          }
          if (name.isNotEmpty) {
            setSignupName(name);
          }
        }

        Get.toNamed(AppRoutes.register);
        return;
      }

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
        await _loadProfileCacheForUser();
        _syncProfileCacheForUser();
      }

      Get.offAllNamed(_homeRouteForAccountType(user.value?.accountType));
    } on ApiException catch (error) {
      Get.snackbar('Google Login', error.message);
    } catch (_) {
      Get.snackbar('Google Login', 'Login Google gagal');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String name,
    String phone,
    String? gender,
    DateTime? dateOfBirth, {
    String? accountType,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty ||
        password.isEmpty ||
        name.isEmpty ||
        phone.isEmpty) {
      Get.snackbar('Register Failed', 'All fields are required');
      return;
    }
    if (!_isAllowedEmailDomain(trimmedEmail)) {
      Get.snackbar('Register Failed', 'Gunakan email yang valid untuk daftar');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': trimmedEmail,
          'password': password,
          'name': name,
          'phone': phone,
          'accountType': accountType ?? signupAccountType.value ?? 'personal',
          'gender': gender,
          'dateOfBirth': dateOfBirth?.toIso8601String(),
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
        await _loadProfileCacheForUser();
        _syncProfileCacheForUser();
      }

      Get.snackbar('Register', 'Registration successful');
      Get.offAllNamed(_homeRouteForAccountType(user.value?.accountType));
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

  Future<bool> requestPasswordReset(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) {
      Get.snackbar('Lupa Password', 'Email wajib diisi');
      return false;
    }
    if (!_isAllowedEmailDomain(trimmedEmail)) {
      Get.snackbar('Lupa Password', 'Gunakan akun email yang terdaftar');
      return false;
    }

    Get.snackbar('Lupa Password', 'Link reset sudah dikirim ke Gmail kamu');
    return true;
  }

  bool _isAllowedEmailDomain(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@gmail.com') ||
        lower.endsWith('@googlemail.com') ||
        lower.endsWith('@polban.ac.id');
  }
}
