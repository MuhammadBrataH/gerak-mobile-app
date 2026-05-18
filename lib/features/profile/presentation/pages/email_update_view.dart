import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class EmailUpdateView extends StatefulWidget {
  const EmailUpdateView({super.key});

  @override
  State<EmailUpdateView> createState() => _EmailUpdateViewState();
}

class _EmailUpdateViewState extends State<EmailUpdateView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map?;
    _emailController = TextEditingController(
      text: (args?['email'] as String?) ?? 'user@gmail.com',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _showToast(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _EmailUpdateTopBar(onBackTap: () => Get.back()),
                  const SizedBox(height: 20),
                  _EmailField(
                    controller: _emailController,
                    onClear: () => _emailController.clear(),
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    label: 'Next',
                    onTap: () => _showToast('Next tapped'),
                  ),
                  const SizedBox(height: 12),
                  _DangerButton(
                    label: 'Hapus Email',
                    onTap: () => _showToast('Hapus email tapped'),
                  ),
                ],
              ),
            ),
            _EmailUpdateBottomNavBar(
              onHomeTap: () => Get.offAllNamed(AppRoutes.dashboard),
              onCommunityTap: () => _showToast('Community tapped'),
              onProfileTap: () => Get.offAllNamed(AppRoutes.profile),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailUpdateTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const _EmailUpdateTopBar({required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(onPressed: onBackTap, icon: const Icon(Icons.arrow_back)),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Update email anda',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                height: 1.6,
                letterSpacing: -1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClear;

  const _EmailField({required this.controller, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: Color(0xFF090909),
        fontSize: 12,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w600,
        height: 1.33,
      ),
      decoration: InputDecoration(
        labelText: 'Email Baru',
        labelStyle: const TextStyle(
          color: Color(0xC4323232),
          fontSize: 12,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          onPressed: onClear,
          icon: const Icon(Icons.cancel, color: Color(0xFF2563EB)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xB7A1A1A1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xB7A1A1A1)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(60),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(60),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF1401),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailUpdateBottomNavBar extends StatelessWidget {
  final VoidCallback onCommunityTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;

  const _EmailUpdateBottomNavBar({
    required this.onCommunityTap,
    required this.onHomeTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 32,
              offset: Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              label: 'COMMUNITY',
              icon: Icons.groups_rounded,
              isActive: false,
              onTap: onCommunityTap,
            ),
            _BottomNavItem(
              label: 'HOME',
              icon: Icons.home_filled,
              isActive: false,
              onTap: onHomeTap,
            ),
            _BottomNavItem(
              label: 'PROFILE',
              icon: Icons.person,
              isActive: true,
              onTap: onProfileTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.white : const Color(0x99475569);

    return SizedBox(
      width: 110,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF357AF3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Icon(icon, color: color, size: 18),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
                    Icon(icon, color: color, size: 18),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
