import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final AuthController _authController = Get.find<AuthController>();
  late final TextEditingController _nameController;
  late final TextEditingController _domicileController;
  late final TextEditingController _bioController;
  final List<String> _selectedSports = [];

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map?;
    final fallbackSports = ['SEPAK BOLA', 'BASKET', 'LARI'];
    _nameController = TextEditingController(
      text: (args?['name'] as String?) ?? _authController.displayName,
    );
    _domicileController = TextEditingController(
      text:
          (args?['domicile'] as String?) ??
          _authController.profileDomicile.value ??
          'Cilegon',
    );
    _bioController = TextEditingController(
      text:
          (args?['bio'] as String?) ??
          _authController.profileBio.value ??
          'By 1',
    );
    _selectedSports
      ..clear()
      ..addAll(
        _authController.currentSports.isNotEmpty
            ? _authController.currentSports
            : fallbackSports,
      );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _domicileController.dispose();
    _bioController.dispose();
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

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    _authController.setProfilePhotoPath(image.path);
    setState(() {});
  }

  Future<void> _openSportsSelector() async {
    final result = await Get.toNamed(
      AppRoutes.sportsAll,
      arguments: {'selected': List<String>.from(_selectedSports)},
    );
    if (result is List) {
      setState(() {
        _selectedSports
          ..clear()
          ..addAll(result.cast<String>());
      });
    }
  }

  void _removeSport(String label) {
    setState(() {
      _selectedSports.remove(label);
    });
  }

  String _sportIconForLabel(String label) {
    const map = {
      'FOOTBALL': 'assets/icons/soccer.svg',
      'SEPAK BOLA': 'assets/icons/soccer.svg',
      'FUTSAL': 'assets/icons/futsal.svg',
      'MINI SOCCER': 'assets/icons/mini_soccer.svg',
      'BASKET': 'assets/icons/basketball.svg',
      'BASKETBALL': 'assets/icons/basketball.svg',
      'BADMINTON': 'assets/icons/badminton.svg',
      'VOLLEY': 'assets/icons/volley.svg',
      'LARI': 'assets/icons/run.svg',
      'RUNNING': 'assets/icons/run.svg',
      'PADEL': 'assets/icons/padel.svg',
      'BILLIARD': 'assets/icons/billiard.svg',
      'CHESS': 'assets/icons/chess.svg',
      'TABLE TENNIS': 'assets/icons/table_tennis.svg',
      'TENNIS FIELD': 'assets/icons/tennis_field.svg',
    };
    return map[label] ?? 'assets/icons/run.svg';
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
                  _EditProfileTopBar(
                    onBackTap: () => Get.back(),
                    onSaveTap: () {
                      _authController.setDisplayName(_nameController.text);
                      _authController.setProfileDomicile(
                        _domicileController.text,
                      );
                      _authController.setProfileBio(_bioController.text);
                      _authController.setSelectedSports(_selectedSports);
                      Get.back(
                        result: {
                          'name': _nameController.text.trim(),
                          'domicile': _domicileController.text.trim(),
                          'bio': _bioController.text.trim(),
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _EditProfileAvatar(
                    imagePath: _authController.currentProfilePhotoPath,
                    onEditTap: _pickProfilePhoto,
                  ),
                  const SizedBox(height: 20),
                  _EditProfileField(
                    label: 'Nama Display',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 12),
                  _EditProfileField(
                    label: 'Domisili',
                    controller: _domicileController,
                  ),
                  const SizedBox(height: 12),
                  _EditProfileField(
                    label: 'Bio',
                    controller: _bioController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final sport in _selectedSports)
                              _SportChip(
                                label: sport,
                                iconAsset: _sportIconForLabel(sport),
                                onRemove: () => _removeSport(sport),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _openSportsSelector,
                        borderRadius: BorderRadius.circular(12),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          child: Text(
                            'LIHAT SEMUA',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 13,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w700,
                              height: 1.23,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => Get.toNamed(AppRoutes.accountInfo),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Text(
                        'Informasi Akun',
                        style: TextStyle(
                          color: const Color(0xFF2563EB),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w600,
                          height: 1,
                          shadows: [
                            BoxShadow(
                              color: const Color(0x662563EB),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _EditProfileBottomNavBar(
              onHomeTap: () => Get.offAllNamed(AppRoutes.dashboard),
              onCommunityTap: () => _showToast('Community tapped'),
              onProfileTap: () => Get.offAllNamed(_authController.profileRoute),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditProfileTopBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onSaveTap;

  const _EditProfileTopBar({required this.onBackTap, required this.onSaveTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackTap,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              const Text(
                'Edit Profil',
                style: TextStyle(
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
          TextButton(
            onPressed: onSaveTap,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              textStyle: const TextStyle(
                fontSize: 17,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 0.94,
                letterSpacing: 1.2,
              ),
            ),
            child: const Text('SIMPAN'),
          ),
        ],
      ),
    );
  }
}

class _EditProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onEditTap;

  const _EditProfileAvatar({required this.imagePath, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: imagePath == null
                ? const Icon(Icons.person, size: 64, color: Color(0xFF94A3B8))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.file(
                      File(imagePath!),
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onEditTap,
                borderRadius: BorderRadius.circular(9999),
                child: Ink(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _EditProfileField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(
        color: Color(0xFF090909),
        fontSize: 12,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w600,
        height: 1.33,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xC4323232),
          fontSize: 12,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
        filled: true,
        fillColor: Colors.white,
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

class _SportChip extends StatelessWidget {
  final String label;
  final String iconAsset;
  final VoidCallback onRemove;

  const _SportChip({
    required this.label,
    required this.iconAsset,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF475569),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 12,
            height: 12,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFAFBFF),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 4),
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
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 12, color: Color(0xFFFAFBFF)),
          ),
        ],
      ),
    );
  }
}

class _EditProfileBottomNavBar extends StatelessWidget {
  final VoidCallback onCommunityTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;

  const _EditProfileBottomNavBar({
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
