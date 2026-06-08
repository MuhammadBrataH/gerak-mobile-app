import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

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
          _buildSection('Keamanan', [
            _SettingsItem(
              icon: Icons.lock_outline,
              title: 'Ubah Kata Sandi',
              onTap: () => Get.toNamed('/profile/password-update'),
            ),
            _SettingsItem(
              icon: Icons.delete_outline,
              title: 'Hapus Akun',
              textColor: Colors.red,
              onTap: () => Get.toNamed('/profile/delete-account'),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('Lainnya', [
            _SettingsItem(
              icon: Icons.info_outline,
              title: 'Tentang Aplikasi',
              onTap: () {
                // Show about dialog
              },
            ),
            _SettingsItem(
              icon: Icons.logout,
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
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? Colors.grey[700], size: 24),
            const SizedBox(width: 16),
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
    );
  }
}
