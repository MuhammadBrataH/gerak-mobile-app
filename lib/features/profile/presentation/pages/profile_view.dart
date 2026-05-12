import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  AuthController get _authController => Get.find<AuthController>();

  String get _displayName => _authController.user.value?.name ?? 'User';
  String get _domicile => 'Indonesia';
  String get _bio => '';

  void _showToast(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void _showProfileMenu(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = 120.0;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(screenWidth - menuWidth - 16, 56, 16, 0),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  _authController.logout();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.login, color: Color(0xFF2563EB), size: 18),
                    const SizedBox(width: 6),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 14,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      elevation: 0,
      color: Colors.transparent,
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
                  _ProfileTopBar(
                    onAvatarTap: () {
                      _showProfileMenu(context);
                    },
                  ),
                  const SizedBox(height: 24),
                  _ProfileHeader(
                    displayName: _displayName,
                    domicile: _domicile,
                  ),
                  const SizedBox(height: 20),
                  _ProfileActions(
                    onSettingsTap: () => Get.toNamed(AppRoutes.accountSettings),
                    onEditTap: () {
                      Get.toNamed(
                        AppRoutes.editProfile,
                        arguments: {
                          'name': _displayName,
                          'domicile': _domicile,
                          'bio': _bio,
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  const _ScheduleHeader(),
                  const SizedBox(height: 16),
                  _ScheduleCardUpcoming(
                    onDetailsTap: () => _showToast('View details tapped'),
                  ),
                  const SizedBox(height: 16),
                  _ScheduleCardPast(),
                ],
              ),
            ),
            _ProfileBottomNavBar(
              onHomeTap: () => Get.offAllNamed(AppRoutes.dashboard),
              onCommunityTap: () => Get.offAllNamed(AppRoutes.community),
              onProfileTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTopBar extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const _ProfileTopBar({required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'GERAK',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w900,
              height: 1.33,
              letterSpacing: -1.2,
            ),
          ),
          GestureDetector(
            onTap: onAvatarTap,
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE2E8F0),
              child: Icon(Icons.person, color: Color(0xFF94A3B8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String displayName;
  final String domicile;

  const _ProfileHeader({required this.displayName, required this.domicile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Icon(
                Icons.person,
                size: 64,
                color: Color(0xFF94A3B8),
              ),
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          displayName,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 36,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w800,
            height: 1.11,
            letterSpacing: -1.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Laki-Laki • 78 • $domicile',
          style: const TextStyle(
            color: Color(0xFF0EA5E9),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w600,
            height: 1.43,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _InterestChip(
              label: 'BASKET',
              iconAsset: 'assets/icons/basketball.svg',
            ),
            _InterestChip(
              label: 'BADMINTON',
              iconAsset: 'assets/icons/badminton.svg',
            ),
            _InterestChip(label: 'LARI', iconAsset: 'assets/icons/run.svg'),
          ],
        ),
      ],
    );
  }
}

class _InterestChip extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _InterestChip({required this.label, required this.iconAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF475569),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 14,
            height: 14,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFAFBFF),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFAFBFF),
              fontSize: 10,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onEditTap;

  const _ProfileActions({required this.onSettingsTap, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSettingsTap,
              borderRadius: BorderRadius.circular(9999),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0x4CCBD5E1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.settings, size: 18, color: Color(0xFF0F172A)),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEditTap,
              borderRadius: BorderRadius.circular(9999),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.16, -0.41),
                    end: Alignment(0.84, 1.41),
                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: const Center(
                  child: Text(
                    'Edit Profil',
                    style: TextStyle(
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
          ),
        ),
      ],
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Jadwal',
      style: TextStyle(
        color: Color(0xFF0F172A),
        fontSize: 30,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.75,
      ),
    );
  }
}

class _ScheduleCardUpcoming extends StatelessWidget {
  final VoidCallback onDetailsTap;

  const _ScheduleCardUpcoming({required this.onDetailsTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 128,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: const Alignment(0.5, 1),
                      end: const Alignment(0.5, 0),
                      colors: [
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF97316),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tomorrow • 08:30 AM',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0EA5E9),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Iron Gym, Downtown',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF475569),
              fontSize: 14,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w500,
              height: 1.43,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Elite Power HIIT Session',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 20,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _MiniAvatar(),
              _MiniAvatar(),
              _MiniAvatar(),
              _MiniCount('+12'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDetailsTap,
                borderRadius: BorderRadius.circular(9999),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Text(
                    'View Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
          ),
        ],
      ),
    );
  }
}

class _ScheduleCardPast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 128,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xFFF1F5F9),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fri, 24 May • 06:00 PM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.43,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Serenity Hub',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vinyasa Flow Advanced',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF475569),
                fontSize: 20,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: const Text(
                'Confirmed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 16,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniAvatar extends StatelessWidget {
  const _MiniAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(Icons.person, size: 12, color: Color(0xFF94A3B8)),
    );
  }
}

class _MiniCount extends StatelessWidget {
  final String label;

  const _MiniCount(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF475569),
          fontSize: 8,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }
}

class _ProfileBottomNavBar extends StatelessWidget {
  final VoidCallback onCommunityTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;

  const _ProfileBottomNavBar({
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
