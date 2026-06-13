import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/routes/app_routes.dart';

class AccountSettingsView extends StatelessWidget {
  const AccountSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pengaturan Akun',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsItem(
            title: 'Informasi Akun',
            onTap: () => Get.toNamed(AppRoutes.accountInfo),
          ),
          const SizedBox(height: 12),
          _SettingsItem(
            title: 'Kata Sandi',
            onTap: () => Get.toNamed('/profile/password-update'),
          ),
          const SizedBox(height: 12),
          _SettingsItem(
            title: 'Tentang Aplikasi',
            onTap: () {
              // Show about dialog
            },
          ),
          const SizedBox(height: 12),
          _SettingsItem(
            title: 'Hapus Akun',
            textColor: Colors.red,
            onTap: () => Get.toNamed(AppRoutes.deleteAccount),
          ),
          const SizedBox(height: 12),
          _SettingsItem(
            title: 'Keluar',
            textColor: Colors.red,
            onTap: () {
              Get.defaultDialog(
                title: 'Konfirmasi Keluar',
                middleText: 'Apakah Anda yakin ingin keluar?',
                textConfirm: 'Ya',
                textCancel: 'Batal',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  Get.find<AuthController>().logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsItem({
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor ?? Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: textColor ?? Colors.grey[400],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
