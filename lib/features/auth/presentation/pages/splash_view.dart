import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Delay for 2 seconds to show splash screen since native splash is not working
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final authController = Get.find<AuthController>();

    // Check if user is logged in
    final isLoggedIn = await authController.isLoggedIn;

    // Check if user has completed onboarding
    final hasCompletedOnboarding = await authController.hasCompletedOnboarding;

    if (isLoggedIn) {
      // User has valid token, navigate to dashboard
      Get.offAllNamed(AppRoutes.dashboard);
    } else if (!hasCompletedOnboarding) {
      // New user, navigate to onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // Returning user without valid token, navigate to login
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full screen splash image
          Positioned.fill(
            child: Image.asset(
              'assets/logo_splashscreen_putih.png',
              fit: BoxFit.cover,
            ),
          ),
          // Loading indicator at 3/4 from top
          Align(
            alignment: const Alignment(0, 0.75),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const LinearProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
