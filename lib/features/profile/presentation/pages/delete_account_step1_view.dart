import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class DeleteAccountStep1View extends StatefulWidget {
  const DeleteAccountStep1View({super.key});

  @override
  State<DeleteAccountStep1View> createState() => _DeleteAccountStep1ViewState();
}

class _DeleteAccountStep1ViewState extends State<DeleteAccountStep1View> {
  int? _selectedIndex;

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
                  const SizedBox(height: 16),
                  const Text(
                    'Sebelum Anda pergi, ada\nyang bisa kami bantu?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                      height: 1.6,
                      letterSpacing: -1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Beri tahu kami alasan Anda ingin menghapus akun agar kami dapat membantu mengatasi masalah\numum dan meningkatkan aplikasi bagi komunitas. Anda dapat melewatkan langkah ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xC4323232),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _ReasonOption(
                    label: 'Masalah keamanan atau privasi',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  const SizedBox(height: 12),
                  _ReasonOption(
                    label: 'Kesulitan dalam memulai penggunaan akun',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  const SizedBox(height: 12),
                  _ReasonOption(
                    label: 'Alasan lainnya',
                    isSelected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  const SizedBox(height: 16),
                  _PrimaryButton(
                    label: 'Lanjut',
                    onTap: () => Get.toNamed(AppRoutes.deleteAccountStep2),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showToast('Lewati tapped'),
                    child: const Text(
                      'Lewati',
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

class _ReasonOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xB7A1A1A1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF090909),
                    fontSize: 15,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.07,
                  ),
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBCBCBC)),
                ),
              ),
            ],
          ),
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
