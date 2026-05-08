import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class DeleteAccountStep2View extends StatelessWidget {
  const DeleteAccountStep2View({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _DeleteAccountTopBar(
                    title: 'Hapus Akun',
                    onBackTap: () => Get.back(),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Anda akan kehilangan akses ke aplikasi Gerak dan akun Anda akan dihapus secara permanen. Semua data profil, aktivitas, dan statistik Anda akan hilang serta tidak dapat dipulihkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xC4323232),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _DeleteWarningCard(),
                  const SizedBox(height: 24),
                  _PrimaryButton(
                    label: 'Hapus Akun',
                    onTap: () => _showToast('Hapus akun tapped'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _DeleteAccountBottomNavBar(
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

class _DeleteAccountTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;

  const _DeleteAccountTopBar({required this.title, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          IconButton(onPressed: onBackTap, icon: const Icon(Icons.arrow_back)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: -1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteWarningCard extends StatelessWidget {
  const _DeleteWarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1ED9D9D9),
            blurRadius: 7,
            offset: Offset(0, 1),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Sebelum menghapus',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.4,
              letterSpacing: -1,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Bacalah informasi berikut ini dan pastikan keputusan Anda.',
            style: TextStyle(
              color: Color(0xC4323232),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
          SizedBox(height: 12),
          _WarningItem(
            title: 'Riwayat aktivitas Anda akan terhapus',
            description:
                'Semua aktivitas, riwayat olahraga, dan statistik tidak dapat dipulihkan setelah akun dihapus.',
          ),
          SizedBox(height: 10),
          _WarningItem(
            title: 'Data profil akan terhapus',
            description:
                'Informasi pribadi dan preferensi akun akan hilang secara permanen.',
          ),
          SizedBox(height: 10),
          _WarningItem(
            title: 'Proses ini tidak dapat dibatalkan',
            description:
                'Setelah akun dihapus, Anda tidak dapat mengaktifkannya kembali.',
          ),
        ],
      ),
    );
  }
}

class _WarningItem extends StatelessWidget {
  final String title;
  final String description;

  const _WarningItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFEF4444),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.23,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xC4323232),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w600,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ),
      ],
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
              color: const Color(0xFFEF4444),
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

class _DeleteAccountBottomNavBar extends StatelessWidget {
  final VoidCallback onCommunityTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;

  const _DeleteAccountBottomNavBar({
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
