import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final Set<String> _selectedCategories = {};
  String _selectedLocation = 'Bandung';

  void _showToast(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _openLocationSheet() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      isScrollControlled: true,
      builder: (context) => const _LocationFilterSheet(),
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _selectedLocation = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final communities = <_CommunityCardData>[
      _CommunityCardData(
        name: 'PLAYMAKER FUN CLUB',
        categories: 'FOOTBALL • PADEL',
        badgeUrl: 'https://placehold.co/98x98',
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
                          onProfileTap: () => Get.toNamed(AppRoutes.profile),
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
                          locationLabel: _selectedLocation,
                          onLocationTap: _openLocationSheet,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'KOMUNITAS',
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
                    itemCount: communities.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _CommunityCard(data: communities[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
            _BottomNavBar(
              onTap: (label) {
                if (label == 'Community') {
                  return;
                }
                if (label == 'Home') {
                  Get.offAllNamed(AppRoutes.dashboard);
                  return;
                }
                if (label == 'Profile') {
                  Get.offAllNamed(AppRoutes.profile);
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
                'CARI KOMUNITAS',
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

class _ChipData {
  final String label;
  final String iconPath;
  const _ChipData(this.label, this.iconPath);
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
      const _ChipData('SEPAK BOLA', 'assets/icons/soccer.svg'),
      const _ChipData('BASKET', 'assets/icons/basketball.svg'),
      const _ChipData('BADMINTON', 'assets/icons/badminton.svg'),
      const _ChipData('LARI', 'assets/icons/run.svg'),
      const _ChipData('PADEL', 'assets/icons/padel.svg'),
      const _ChipData('FUTSAL', 'assets/icons/futsal.svg'),
      const _ChipData('VOLLEY', 'assets/icons/volley.svg'),
      const _ChipData('MINI SOCCER', 'assets/icons/mini_soccer.svg'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((chip) {
        final isActive = selectedLabels.contains(chip.label);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onCategoryTap(chip.label),
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
                    chip.iconPath,
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFFAFBFF),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    chip.label,
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
  final String locationLabel;
  final VoidCallback onLocationTap;

  const _FilterRow({required this.locationLabel, required this.onLocationTap});

  @override
  Widget build(BuildContext context) {
    return _FilterChip(
      icon: Icons.place,
      label: locationLabel,
      onTap: onLocationTap,
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

class _LocationFilterSheet extends StatefulWidget {
  const _LocationFilterSheet();

  @override
  State<_LocationFilterSheet> createState() => _LocationFilterSheetState();
}

class _LocationFilterSheetState extends State<_LocationFilterSheet> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  final List<String> _cities = const [
    'Ambon',
    'Balikpapan',
    'Bandung',
    'Banjarmasin',
    'Batam',
    'Bekasi',
    'Bogor',
    'Cilegon',
    'Denpasar',
    'Jakarta',
    'Makassar',
    'Malang',
    'Manado',
    'Medan',
    'Padang',
    'Palembang',
    'Pekanbaru',
    'Semarang',
    'Surabaya',
    'Yogyakarta',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _cities
        .where((city) => city.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            border: Border(
              top: BorderSide(color: Color(0x80000000), width: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 102,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFF9199A5),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 20,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.8,
                    letterSpacing: -0.75,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Masukkan kata kunci',
                    hintStyle: TextStyle(
                      color: Color(0x7F0F172A),
                      fontSize: 20,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w300,
                      height: 1.8,
                      letterSpacing: -0.75,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0x33000000)),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFF808080)),
                  itemBuilder: (context, index) {
                    final city = filtered[index];
                    return ListTile(
                      title: Text(
                        city,
                        style: const TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 20,
                          fontFamily: 'Lexend',
                          fontWeight: FontWeight.w400,
                          height: 1.8,
                          letterSpacing: -0.75,
                        ),
                      ),
                      onTap: () => Get.back(result: city),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final _CommunityCardData data;

  const _CommunityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.communityProfile,
          arguments: {
            'name': data.name,
            'badgeUrl': data.badgeUrl,
            'categories': data.categories,
          },
        ),
        borderRadius: BorderRadius.circular(32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0x4CE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 24,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.categories,
                      style: const TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 10,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 49,
                backgroundImage: NetworkImage(data.badgeUrl),
              ),
            ],
          ),
        ),
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
              isActive: true,
              onTap: () => onTap('Community'),
            ),
            _NavItem(
              label: 'HOME',
              icon: Icons.home_filled,
              isActive: false,
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

class _CommunityCardData {
  final String name;
  final String categories;
  final String badgeUrl;

  const _CommunityCardData({
    required this.name,
    required this.categories,
    required this.badgeUrl,
  });
}
