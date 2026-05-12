import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../../data/models/event_model.dart';
import '../../../../core/routes/app_routes.dart';
import './activity_detail_view.dart';

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
  String _selectedLocation = 'Bandung';
  DateTime _selectedDate = DateTime.now();

  EventController get _eventController => Get.find<EventController>();

  // Map sport category labels to API sport values
  static const _categoryToSport = {
    'SEPAK BOLA': 'football',
    'BASKET': 'basketball',
    'BADMINTON': 'badminton',
    'LARI': 'running',
    'PADEL': 'padel',
    'FUTSAL': 'futsal',
    'VOLLEY': 'volleyball',
    'MINI SOCCER': 'mini_soccer',
  };

  // Map sport type to icon asset
  static const _sportToIcon = {
    'football': 'assets/icons/soccer.svg',
    'basketball': 'assets/icons/basketball.svg',
    'badminton': 'assets/icons/badminton.svg',
    'running': 'assets/icons/run.svg',
    'padel': 'assets/icons/padel.svg',
    'futsal': 'assets/icons/futsal.svg',
    'volleyball': 'assets/icons/volley.svg',
    'mini_soccer': 'assets/icons/mini_soccer.svg',
    'tennis': 'assets/icons/tennis_field.svg',
  };

  void _applyFilters() {
    final sports = _selectedCategories
        .map((label) => _categoryToSport[label])
        .where((s) => s != null)
        .toList();
    _eventController.fetchEventsDebounced(
      city: _selectedLocation,
      sport: sports.isNotEmpty ? sports.first : null,
    );
  }

  _ActivityCardData _eventToCardData(EventModel event) {
    final sportLabel = event.sport.toUpperCase();
    final levelLabel = event.level.toUpperCase();
    final icon = _sportToIcon[event.sport.toLowerCase()] ?? 'assets/icons/soccer.svg';
    final startStr = event.startTime != null
        ? '${event.startTime!.day}/${event.startTime!.month}/${event.startTime!.year} ${event.startTime!.hour.toString().padLeft(2, '0')}:${event.startTime!.minute.toString().padLeft(2, '0')}'
        : 'TBD';
    final endStr = event.endTime != null
        ? '${event.endTime!.hour.toString().padLeft(2, '0')}:${event.endTime!.minute.toString().padLeft(2, '0')}'
        : '';
    final timeStr = endStr.isNotEmpty ? '$startStr - $endStr' : startStr;
    final slots = event.maxSlots != null
        ? '${event.joinedUsers.length}/${event.maxSlots}'
        : '${event.joinedUsers.length} joined';

    return _ActivityCardData(
      id: event.id,
      label: '$sportLabel • $levelLabel',
      labelColor: const Color(0xFF2563EB),
      title: event.name.toUpperCase(),
      time: timeStr,
      location: event.location.toUpperCase(),
      address: '${event.location}, ${event.city}${event.district != null ? ', ${event.district}' : ''}',
      community: '',
      description: event.description ?? '',
      price: '',
      labelIconAsset: icon,
      badgeUrl: 'assets/sample 1.jpg',
      backgroundColor: const Color(0xFFF1F5F9),
      participants: slots,
    );
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
      builder: (context) {
        return const _LocationFilterSheet();
      },
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _selectedLocation = selected;
      });
      _eventController.fetchEvents(city: selected);
    }
  }

  Future<void> _openDateSheet() async {
    final selected = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      isScrollControlled: true,
      builder: (context) {
        return _DateFilterSheet(initialDate: _selectedDate);
      },
    );
    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  String _formatDateLabel(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
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
                  Get.offAllNamed(AppRoutes.login);
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

  void _openSearchSheet(List<_ActivityCardData> activities) {
    final textController = TextEditingController();
    List<_ActivityCardData> filteredActivities = activities;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        setState(() {
                          filteredActivities = activities
                              .where(
                                (activity) =>
                                    activity.title.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) ||
                                    activity.location.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ) ||
                                    activity.label.toLowerCase().contains(
                                      value.toLowerCase(),
                                    ),
                              )
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari aktivitas...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: filteredActivities.length,
                      itemBuilder: (context, index) {
                        final activity = filteredActivities[index];
                        return ListTile(
                          leading: SvgPicture.asset(
                            activity.labelIconAsset,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(activity.title.replaceAll('\n', ' ')),
                          subtitle: Text(activity.location),
                          onTap: () {
                            Get.back();
                            Get.to(
                              () => ActivityDetailView(
                                title: activity.title.replaceAll('\n', ' '),
                                label: activity.label,
                                labelColor: activity.labelColor,
                                time: activity.time,
                                location: activity.location,
                                address: activity.address,
                                community: activity.community,
                                description: activity.description,
                                price: activity.price,
                                participants: '8/44',
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        _TopBar(onProfileTap: () => _showProfileMenu(context)),
                        const SizedBox(height: 20),
                        const _HeroHeadline(),
                        const SizedBox(height: 18),
                        Obx(() {
                          final apiActivities = _eventController.events
                              .map(_eventToCardData)
                              .toList();
                          return _SearchBar(onTap: () => _openSearchSheet(apiActivities));
                        }),
                        const SizedBox(height: 24),
                        _SectionHeader(
                          title: 'KATEGORI',
                          action: 'LIHAT SEMUA',
                          onActionTap: () => Get.toNamed(AppRoutes.sportsAll),
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
                            _applyFilters();
                          },
                        ),
                        const SizedBox(height: 16),
                        _FilterRow(
                          locationLabel: _selectedLocation,
                          dateLabel: _formatDateLabel(_selectedDate),
                          onLocationTap: _openLocationSheet,
                          onDateTap: _openDateSheet,
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
                // Activity list from API
                Obx(() {
                  if (_eventController.isLoading.value && _eventController.events.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                      ),
                    );
                  }

                  final activities = _eventController.events
                      .map(_eventToCardData)
                      .toList();

                  if (activities.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada aktivitas',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'Lexend',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Coba ubah filter atau lokasi',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[400],
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
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
                  );
                }),
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
                if (label == 'Community') {
                  Get.offAllNamed(AppRoutes.community);
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
  final VoidCallback onProfileTap;

  const _TopBar({required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
            onTap: onProfileTap,
            child: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/sample 1.jpg'),
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
                    width: 14,
                    height: 14,
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
  final String locationLabel;
  final String dateLabel;
  final VoidCallback onLocationTap;
  final VoidCallback onDateTap;

  const _FilterRow({
    required this.locationLabel,
    required this.dateLabel,
    required this.onLocationTap,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChip(
            icon: Icons.place,
            label: locationLabel,
            onTap: onLocationTap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _FilterChip(
            icon: Icons.calendar_month,
            label: dateLabel,
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

class _DateFilterSheet extends StatefulWidget {
  final DateTime initialDate;

  const _DateFilterSheet({required this.initialDate});

  @override
  State<_DateFilterSheet> createState() => _DateFilterSheetState();
}

class _DateFilterSheetState extends State<_DateFilterSheet> {
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  late DateTime _currentMonth;

  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const _dayNames = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  bool get _canGoPrev {
    return _visibleMonth.isAfter(_currentMonth);
  }

  void _goPrevMonth() {
    if (!_canGoPrev) return;
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  int _daysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  String _formatHeader(DateTime date) {
    final dayNames = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final dayName = dayNames[date.weekday % 7];
    final monthName = _monthNames[date.month - 1];
    return '$dayName, $monthName ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth(_visibleMonth);
    final firstWeekday = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    ).weekday;
    final leadingEmpty = firstWeekday % 7;
    final totalCells = leadingEmpty + daysInMonth;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 102,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9199A5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w300,
                      height: 2.4,
                      letterSpacing: -0.75,
                    ),
                  ),
                  Text(
                    _formatHeader(_selectedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                      height: 1.29,
                      letterSpacing: -0.75,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 17,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                              height: 2.12,
                              letterSpacing: -0.75,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _canGoPrev ? _goPrevMonth : null,
                            icon: Icon(
                              Icons.chevron_left,
                              color: _canGoPrev
                                  ? const Color(0xFF0F172A)
                                  : const Color(0x660F172A),
                            ),
                          ),
                          IconButton(
                            onPressed: _goNextMonth,
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _dayNames
                            .map(
                              (day) => SizedBox(
                                width: 36,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xB20F172A),
                                    fontSize: 15,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    height: 2.4,
                                    letterSpacing: -0.75,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: totalCells,
                        itemBuilder: (context, index) {
                          if (index < leadingEmpty) {
                            return const SizedBox.shrink();
                          }
                          final day = index - leadingEmpty + 1;
                          final date = DateTime(
                            _visibleMonth.year,
                            _visibleMonth.month,
                            day,
                          );
                          final isSelected =
                              date.year == _selectedDate.year &&
                              date.month == _selectedDate.month &&
                              date.day == _selectedDate.day;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xCC0F172A),
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 2.4,
                                  letterSpacing: -0.75,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 20,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 1.8,
                                letterSpacing: -0.75,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () => Get.back(result: _selectedDate),
                              child: const Text(
                                'SIMPAN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 1.8,
                                  letterSpacing: -0.75,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ActivityDetailView(
            eventId: data.id,
            title: data.title.replaceAll('\n', ' '),
            label: data.label,
            labelColor: data.labelColor,
            time: data.time,
            location: data.location,
            address: data.address,
            community: data.community,
            description: data.description,
            price: data.price,
            participants: data.participants,
          ),
        );
      },
      child: Container(
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
                  colorFilter: ColorFilter.mode(
                    data.labelColor,
                    BlendMode.srcIn,
                  ),
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
                  backgroundImage: AssetImage(data.badgeUrl),
                ),
              ],
            ),
          ],
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

class _ActivityCardData {
  final String id;
  final String label;
  final Color labelColor;
  final String title;
  final String time;
  final String location;
  final String address;
  final String community;
  final String description;
  final String price;
  final String labelIconAsset;
  final String badgeUrl;
  final Color backgroundColor;
  final String participants;

  const _ActivityCardData({
    required this.id,
    required this.label,
    required this.labelColor,
    required this.title,
    required this.time,
    required this.location,
    required this.address,
    required this.community,
    required this.description,
    required this.price,
    required this.labelIconAsset,
    required this.badgeUrl,
    required this.backgroundColor,
    this.participants = '',
  });
}

class _ChipData {
  final String label;
  final String iconAsset;

  const _ChipData(this.label, this.iconAsset);
}
