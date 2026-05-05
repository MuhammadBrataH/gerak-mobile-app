import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/routes/app_routes.dart';

class DashboardView extends GetView<AuthController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Set<String> _selectedCategories = {};

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
    final activities = <_ActivityCardData>[
      _ActivityCardData(
        label: 'FOOTBALL • ELITE TIER',
        labelColor: const Color(0xFF2563EB),
        title: 'GIMMICK LEAGUE\nWEEK 3',
        time: 'TODAY, 20:00',
        location: 'CIJERAH SOCCER ARENA',
        labelIconAsset: 'assets/icons/soccer.svg',
        badgeUrl: 'https://placehold.co/44x44',
        backgroundColor: const Color(0xFFF1F5F9),
      ),
      _ActivityCardData(
        label: 'RUNNING • SOCIAL',
        labelColor: const Color(0xFF005F8A),
        title: 'JOGGING\nBARENG',
        time: 'SUN, 07:00',
        location: 'TAMAN MALUKU BANDUNG',
        labelIconAsset: 'assets/icons/run.svg',
        badgeUrl: 'https://placehold.co/39x39',
        backgroundColor: const Color(0xFFB1C8FC),
      ),
      _ActivityCardData(
        label: 'PADEL • FUN MATCH',
        labelColor: const Color(0xFF2563EB),
        title: 'PLAYPADEL\nBANDUNG',
        time: 'SAT, 19:00',
        location: 'LARS PADEL BANDUNG',
        labelIconAsset: 'assets/icons/padel.svg',
        badgeUrl: 'https://placehold.co/44x44',
        backgroundColor: const Color(0xFFF1F5F9),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(
                          onMenuTap: () => _showToast('Menu tapped'),
                          onProfileTap: () => _showToast('Profile tapped'),
                        ),
                        const SizedBox(height: 20),
                        const _HeroHeadline(),
                        const SizedBox(height: 18),
                        _SearchBar(onTap: () => _showToast('Search tapped')),
                        const SizedBox(height: 24),
                        _SectionHeader(
                          title: 'KATEGORI',
                          action: 'LIHAT SEMUA',
                          onActionTap: () => _showToast('Lihat semua tapped'),
                        ),
                        const SizedBox(height: 12),
                        _CategoryChips(
                          selectedLabels: _selectedCategories,
                          onCategoryTap: (label) {
                            setState(() {
                              if (_selectedCategories.contains(label)) {
                                _selectedCategories.remove(label);
                              } else {
                                _selectedCategories.add(label);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        _FilterRow(
                          onLocationTap: () => _showToast('Lokasi tapped'),
                          onDateTap: () => _showToast('Tanggal tapped'),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'AKTIVITAS',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.w700,
                            height: 1,
                            letterSpacing: -0.6,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 140),
                  sliver: SliverList.builder(
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _ActivityCard(data: activities[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
            _BottomNavBar(
              onTap: (label) {
                if (label == 'Home') {
                  return;
                }
                if (label == 'Profile') {
                  Get.toNamed(AppRoutes.profile);
                  return;
                }
                _showToast('Nav: $label');
              },
            ),
            _FloatingActionButton(onTap: () => _showToast('Add tapped')),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  const _TopBar({required this.onMenuTap, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onMenuTap,
                icon: const Icon(Icons.menu_rounded),
              ),
              const SizedBox(width: 8),
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
            ],
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://placehold.co/32x32'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 48,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w800,
          height: 1,
          letterSpacing: -2.4,
        ),
        children: [
          TextSpan(
            text: 'PULSE OF\n',
            style: TextStyle(color: Color(0xFF0F172A)),
          ),
          TextSpan(
            text: 'MOTION.',
            style: TextStyle(color: Color(0xFF2563EB)),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(48),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(48),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: const [
              Icon(Icons.search, color: Color(0xFF94A3B8)),
              SizedBox(width: 12),
              Text(
                'CARI AKTIVITAS',
                style: TextStyle(
                  color: Color(0x99475569),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 24,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w700,
            height: 1.33,
            letterSpacing: -0.6,
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final Set<String> selectedLabels;
  final ValueChanged<String> onCategoryTap;

  const _CategoryChips({
    required this.selectedLabels,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      _ChipData('SEPAK BOLA', 'assets/icons/soccer.svg'),
      _ChipData('BASKET', 'assets/icons/basketball.svg'),
      _ChipData('BADMINTON', 'assets/icons/badminton.svg'),
      _ChipData('LARI', 'assets/icons/run.svg'),
      _ChipData('PADEL', 'assets/icons/padel.svg'),
      _ChipData('FUTSAL', 'assets/icons/futsal.svg'),
      _ChipData('VOLLEY', 'assets/icons/volley.svg'),
      _ChipData('MINI SOCCER', 'assets/icons/mini_soccer.svg'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isActive = selectedLabels.contains(category.label);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onCategoryTap(category.label),
            borderRadius: BorderRadius.circular(10),
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF475569),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    category.iconAsset,
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFAFBFF),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
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
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final VoidCallback onLocationTap;
  final VoidCallback onDateTap;

  const _FilterRow({required this.onLocationTap, required this.onDateTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChip(
            icon: Icons.place,
            label: 'Bandung',
            onTap: onLocationTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FilterChip(
            icon: Icons.calendar_month,
            label: '21-04-2026',
            onTap: onDateTap,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF0F172A)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 13,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: Color(0xFF0F172A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final _ActivityCardData data;

  const _ActivityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: data.backgroundColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x4CE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                data.labelIconAsset,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(data.labelColor, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(
                data.label,
                style: TextStyle(
                  color: data.labelColor,
                  fontSize: 10,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w900,
                  height: 1.5,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 30,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          data.time,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 12,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.place,
                          size: 14,
                          color: Color(0xFF475569),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            data.location,
                            style: const TextStyle(
                              color: Color(0xFF475569),
                              fontSize: 12,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w500,
                              height: 1.33,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(data.badgeUrl),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final ValueChanged<String> onTap;

  const _BottomNavBar({required this.onTap});

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
            _NavItem(
              label: 'COMMUNITY',
              icon: Icons.groups_rounded,
              isActive: false,
              onTap: () => onTap('Community'),
            ),
            _NavItem(
              label: 'HOME',
              icon: Icons.home_filled,
              isActive: true,
              onTap: () => onTap('Home'),
            ),
            _NavItem(
              label: 'PROFILE',
              icon: Icons.person,
              isActive: false,
              onTap: () => onTap('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.white : const Color(0x99475569);

    return SizedBox(
      width: 80,
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

class _FloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FloatingActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 96,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9999),
          child: Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(0, 0),
                end: Alignment(1, 1),
                colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              ),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _ActivityCardData {
  final String label;
  final Color labelColor;
  final String title;
  final String time;
  final String location;
  final String labelIconAsset;
  final String badgeUrl;
  final Color backgroundColor;

  const _ActivityCardData({
    required this.label,
    required this.labelColor,
    required this.title,
    required this.time,
    required this.location,
    required this.labelIconAsset,
    required this.badgeUrl,
    required this.backgroundColor,
  });
}

class _ChipData {
  final String label;
  final String iconAsset;

  const _ChipData(this.label, this.iconAsset);
}
