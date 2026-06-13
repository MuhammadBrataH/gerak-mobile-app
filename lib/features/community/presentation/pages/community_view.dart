import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/media_source_image.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import './community_add_sheet.dart';
import './community_profile_view.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final Set<String> _selectedCategories = {};
  String _selectedLocation = 'Bandung';
  final ApiClient _apiClient = ApiClient();
  List<_CommunityCardData> _communities = [];
  bool _isLoading = true;
  String _searchQuery = '';

  List<_CommunityCardData> get _filteredCommunities {
    var filtered = _communities;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((community) {
        return community.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            community.categories.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // Filter by selected categories
    if (_selectedCategories.isNotEmpty) {
      filtered = filtered.where((community) {
        final communityCategories = community.categories.toLowerCase().split(
          ' • ',
        );
        return _selectedCategories.any((selected) {
          return communityCategories.any(
            (cat) => cat.contains(selected.toLowerCase()),
          );
        });
      }).toList();
    }

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final resp = await _apiClient.get<Map<String, dynamic>>(
        '/auth/communities',
      );
      final data = resp.data ?? {};
      final items = data['communities'];
      if (items is List) {
        setState(() {
          _communities = items.whereType<Map<String, dynamic>>().map((m) {
            return _CommunityCardData(
              id: m['_id']?.toString() ?? '',
              name: (m['name'] ?? '').toString(),
              categories:
                  (m['sports'] is List && (m['sports'] as List).isNotEmpty)
                  ? (m['sports'] as List).join(' • ').toUpperCase()
                  : 'GENERAL',
              badgeUrl: m['photoUrl'] is String && m['photoUrl']!.isNotEmpty
                  ? m['photoUrl'] as String
                  : 'assets/sample 1.jpg',
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  Future<void> _openAddSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const CommunityAddSheet();
      },
    );
  }

  void _showProfileMenu(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final menuWidth = 120.0;
    final authController = Get.find<AuthController>();
    final isLoggedIn = authController.user.value != null;

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
                  if (isLoggedIn) {
                    authController.logout();
                  } else {
                    Get.offAllNamed(AppRoutes.login);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isLoggedIn ? Icons.logout : Icons.login,
                      color: const Color(0xFF2563EB),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isLoggedIn ? 'Logout' : 'Login',
                      style: const TextStyle(
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

  void _openSearchSheet() {
    final communities = _filteredCommunities;
    final textController = TextEditingController();
    List<_CommunityCardData> filteredCommunities = communities;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 64,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFECF2FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textController,
                              onChanged: (value) {
                                setState(() {
                                  final q = value.toLowerCase();
                                  filteredCommunities = communities
                                      .where(
                                        (community) =>
                                            community.name
                                                .toLowerCase()
                                                .contains(q) ||
                                            community.categories
                                                .toLowerCase()
                                                .contains(q),
                                      )
                                      .toList();
                                });
                              },
                              style: const TextStyle(
                                fontSize: 15,
                                fontFamily: 'Lexend',
                                color: Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: const Color(0xFFF7FAFC),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF94A3B8),
                                ),
                                hintText: 'Cari komunitas...',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              textController.clear();
                              setState(() {
                                filteredCommunities = communities;
                              });
                            },
                            child: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: filteredCommunities.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Color(0xFF94A3B8),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Tidak ada komunitas ditemukan',
                                    style: TextStyle(
                                      color: Color(0xFF94A3B8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              itemCount: filteredCommunities.length,
                              itemBuilder: (context, index) {
                                final community = filteredCommunities[index];
                                return _CommunityCard(
                                  data: community,
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed(
                                      AppRoutes.communityProfile,
                                      arguments: {
                                        'id': community.id,
                                        'name': community.name,
                                        'badgeUrl': community.badgeUrl,
                                        'categories': community.categories,
                                        'isOwnProfile': false,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final communities = _filteredCommunities;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => _TopBar(
                onAddTap: authController.isCommunityAccount
                    ? _openAddSheet
                    : null,
                onSearchTap: _openSearchSheet,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                title: 'KATEGORI',
                                action: 'LIHAT SEMUA',
                                onActionTap: () =>
                                    Get.toNamed(AppRoutes.sportsAll),
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
                        sliver: _isLoading
                            ? SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(48),
                                    child: CircularProgressIndicator(
                                      color: const Color(0xFF2563EB),
                                    ),
                                  ),
                                ),
                              )
                            : SliverList.builder(
                                itemCount: communities.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: _CommunityCard(
                                      data: communities[index],
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommunityProfileView(),
                                            settings: RouteSettings(
                                              arguments: {
                                                'id': communities[index].id,
                                                'name': communities[index].name,
                                                'badgeUrl':
                                                    communities[index].badgeUrl,
                                                'categories': communities[index]
                                                    .categories,
                                                'isOwnProfile':
                                                    authController
                                                        .isCommunityAccount &&
                                                    communities[index].id ==
                                                        authController
                                                            .user
                                                            .value
                                                            ?.id,
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
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
                        Get.offAllNamed(Get.find<AuthController>().homeRoute);
                        return;
                      }
                      if (label == 'Profile') {
                        final authController = Get.find<AuthController>();
                        if (authController.isCommunityAccount) {
                          Get.offAllNamed(
                            AppRoutes.communityProfile,
                            arguments: {'isOwnProfile': true},
                          );
                        } else {
                          Get.offAllNamed(AppRoutes.profile);
                        }
                        return;
                      }
                      _showToast('Nav: $label');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback? onAddTap;
  final VoidCallback onSearchTap;

  const _TopBar({required this.onAddTap, required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 32,
            child: onAddTap == null
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: onAddTap,
                    icon: const Icon(Icons.add, color: Color(0xFF0F172A)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
          ),
          Expanded(
            child: Center(
              child: const Text(
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
            ),
          ),
          IconButton(
            onPressed: onSearchTap,
            icon: const Icon(Icons.search_rounded, color: Color(0xFF0F172A)),
            tooltip: 'Cari',
          ),
        ],
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
                  separatorBuilder: (context, index) =>
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
  final VoidCallback onTap;

  const _CommunityCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
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
                      maxLines: 2,
                      overflow: TextOverflow.visible,
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
                backgroundImage: AssetImage(data.badgeUrl),
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
      width: 120,
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
                        maxLines: 1,
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

class _CommunityCardData {
  final String id;
  final String name;
  final String categories;
  final String badgeUrl;

  const _CommunityCardData({
    this.id = '',
    required this.name,
    required this.categories,
    required this.badgeUrl,
  });
}
