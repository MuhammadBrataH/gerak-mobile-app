import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/media_source_image.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../events/data/models/event_model.dart';
import '../../../events/presentation/controllers/event_controller.dart';
import './community_add_sheet.dart';

class CommunityProfileView extends StatefulWidget {
  const CommunityProfileView({super.key});

  @override
  State<CommunityProfileView> createState() => _CommunityProfileViewState();
}

class _CommunityProfileViewState extends State<CommunityProfileView> {
  static const _fallbackSports = ['BASKET', 'BADMINTON', 'LARI'];
  late final EventController _eventController;
  late Future<List<EventModel>> _postEventsFuture;
  late Future<List<EventModel>> _matchEventsFuture;

  @override
  void initState() {
    super.initState();
    _eventController = Get.find<EventController>();
    _reloadContent();
  }

  void _reloadContent() {
    final authController = Get.find<AuthController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final creatorId =
        (args['id'] as String?) ?? authController.user.value?.id ?? '';

    if (creatorId.isEmpty) {
      _postEventsFuture = Future.value(const <EventModel>[]);
      _matchEventsFuture = Future.value(const <EventModel>[]);
      return;
    }

    _postEventsFuture = _eventController.fetchEventsAsList(
      createdBy: creatorId,
      activityType: 'post',
      limit: 50,
    );
    _matchEventsFuture = _eventController.fetchEventsAsList(
      createdBy: creatorId,
      activityType: 'match',
      limit: 50,
    );
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

    if (mounted) {
      setState(_reloadContent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final communityName = (args['name'] as String?) ?? 'Komunitas';
    final est = (args['est'] as String?) ?? 'EST. 2019';
    final memberCount = (args['members'] as int?) ?? 500;
    final imagePath =
        (args['badgeUrl'] as String?) ?? authController.currentProfilePhotoPath;

    final categoriesStr = (args['categories'] as String?) ?? '';
    final sports = categoriesStr.isNotEmpty
        ? categoriesStr.split(' • ')
        : (authController.currentSports.isNotEmpty
              ? authController.currentSports
              : _fallbackSports);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Obx(
                      () => _TopBar(
                        imagePath: imagePath,
                        onAddTap: authController.isCommunityAccount
                            ? _openAddSheet
                            : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _CommunityHeader(
                            imagePath: imagePath,
                            communityName: communityName,
                            est: est,
                            sports: sports,
                            memberCount: memberCount,
                            onSettingsTap: () =>
                                Get.toNamed(AppRoutes.accountSettings),
                            onEditTap: () async {
                              await Get.toNamed(AppRoutes.editProfile);
                              if (mounted) {
                                setState(_reloadContent);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          const _ProfileTabs(),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 540,
                            child: TabBarView(
                              children: [
                                _PostinganTab(
                                  communityName: communityName,
                                  avatarPath: imagePath,
                                  eventsFuture: _postEventsFuture,
                                ),
                                _PertandinganTab(
                                  communityName: communityName,
                                  avatarPath: imagePath,
                                  eventsFuture: _matchEventsFuture,
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
              _CommunityProfileBottomNavBar(
                onCommunityTap: () => Get.offAllNamed(AppRoutes.community),
                onHomeTap: () => Get.offAllNamed(AppRoutes.dashboard),
                onProfileTap: () => Get.offAllNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onAddTap;

  const _TopBar({required this.imagePath, required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
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
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFE2E8F0),
            backgroundImage: buildImageProviderFromSource(imagePath),
            child: imagePath == null
                ? const Icon(Icons.person, color: Color(0xFF94A3B8), size: 18)
                : null,
          ),
        ],
      ),
    );
  }
}

class _CommunityHeader extends StatelessWidget {
  final String? imagePath;
  final String communityName;
  final String est;
  final List<String> sports;
  final int memberCount;
  final VoidCallback onSettingsTap;
  final VoidCallback onEditTap;

  const _CommunityHeader({
    required this.imagePath,
    required this.communityName,
    required this.est,
    required this.sports,
    required this.memberCount,
    required this.onSettingsTap,
    required this.onEditTap,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
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
                    ? const Icon(
                        Icons.groups,
                        size: 64,
                        color: Color(0xFF94A3B8),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          image: buildImageProviderFromSource(imagePath),
                          width: 128,
                          height: 128,
                          fit: BoxFit.cover,
                        ),
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
        ),
        const SizedBox(height: 12),
        Text(
          communityName,
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
          est,
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
          children: sports
              .map(
                (sport) => _SportChip(
                  label: sport,
                  iconAsset: _sportIconForLabel(sport),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              memberCount.toString(),
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 22,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Members',
              style: TextStyle(
                color: Color(0xCC0F172A),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onSettingsTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  backgroundColor: const Color(0xFFE2E8F0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.settings, size: 18, color: Color(0xFF0F172A)),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onEditTap,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  backgroundColor: const Color(0xFF2563EB),
                ),
                child: const Text(
                  'Edit Profil',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs();

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      labelColor: Color(0xFF0F172A),
      unselectedLabelColor: Color(0xFF475569),
      indicatorColor: Color(0xFF2563EB),
      indicatorWeight: 2,
      labelStyle: TextStyle(
        fontSize: 12,
        fontFamily: 'Lexend',
        fontWeight: FontWeight.w800,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      tabs: [
        Tab(text: 'Postingan'),
        Tab(text: 'Pertandingan'),
      ],
    );
  }
}

class _PostinganTab extends StatelessWidget {
  final String communityName;
  final String? avatarPath;
  final Future<List<EventModel>> eventsFuture;

  const _PostinganTab({
    required this.communityName,
    required this.avatarPath,
    required this.eventsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final events = snapshot.data ?? const <EventModel>[];
        if (events.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada postingan',
              style: TextStyle(
                color: Color(0xFF475569),
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
              ),
            ),
          );
        }

        final posts = events.map((event) {
          return _PostData(
            communityName: communityName,
            timeAgo: _formatRelativeTime(event.createdAt),
            content: event.description?.trim().isNotEmpty == true
                ? event.description!.trim()
                : event.name,
            mediaUrl: event.imageUrl,
            avatarProvider: _buildAvatarProvider(avatarPath),
            hasReadMore: (event.description?.trim().length ?? 0) > 96,
          );
        }).toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => _PostCard(data: posts[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: posts.length,
        );
      },
    );
  }
}

class _PertandinganTab extends StatelessWidget {
  final String communityName;
  final String? avatarPath;
  final Future<List<EventModel>> eventsFuture;

  const _PertandinganTab({
    required this.communityName,
    required this.avatarPath,
    required this.eventsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
      future: eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF2563EB)),
          );
        }

        final events = snapshot.data ?? const <EventModel>[];
        if (events.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada pertandingan',
              style: TextStyle(
                color: Color(0xFF475569),
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
              ),
            ),
          );
        }

        final matches = events.map((event) {
          return _MatchData(
            sportLabel: event.sport.toUpperCase(),
            title: event.name,
            dateTime: _formatMatchDateTime(event.startTime),
            location: event.location,
            avatarProvider: _buildAvatarProvider(event.imageUrl ?? avatarPath),
          );
        }).toList();

        return ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) => _MatchCard(data: matches[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: matches.length,
        );
      },
    );
  }
}

String _formatRelativeTime(DateTime? value) {
  if (value == null) {
    return 'Baru saja';
  }

  final difference = DateTime.now().difference(value);
  if (difference.inMinutes < 1) {
    return 'Baru saja';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes} menit yang lalu';
  }
  if (difference.inDays < 1) {
    return '${difference.inHours} jam yang lalu';
  }
  if (difference.inDays < 7) {
    return '${difference.inDays} hari yang lalu';
  }
  final weeks = (difference.inDays / 7).floor();
  return '$weeks minggu yang lalu';
}

String _formatMatchDateTime(DateTime? value) {
  if (value == null) {
    return 'TBD';
  }

  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/${value.year} • $hour:$minute';
}

ImageProvider _buildAvatarProvider(String? path) {
  return buildImageProviderFromSource(path);
}

class _PostData {
  final String communityName;
  final String timeAgo;
  final String content;
  final String? mediaUrl;
  final ImageProvider avatarProvider;
  final bool hasReadMore;

  const _PostData({
    required this.communityName,
    required this.timeAgo,
    required this.content,
    required this.mediaUrl,
    required this.avatarProvider,
    required this.hasReadMore,
  });
}

class _PostCard extends StatelessWidget {
  final _PostData data;

  const _PostCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: data.avatarProvider,
                backgroundColor: const Color(0xFFE2E8F0),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.communityName,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    data.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: data.content,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 12,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                if (data.hasReadMore)
                  const TextSpan(
                    text: '...Baca selengkapnya',
                    style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: buildMediaPreviewFromSource(data.mediaUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchData {
  final String sportLabel;
  final String title;
  final String dateTime;
  final String location;
  final ImageProvider avatarProvider;

  const _MatchData({
    required this.sportLabel,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.avatarProvider,
  });
}

class _MatchCard extends StatelessWidget {
  final _MatchData data;

  const _MatchCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sports_soccer,
                size: 14,
                color: Color(0xFF2563EB),
              ),
              const SizedBox(width: 6),
              Text(
                data.sportLabel,
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 10,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 28,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                        data.dateTime,
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF475569),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data.location,
                        style: const TextStyle(
                          color: Color(0xFF475569),
                          fontSize: 12,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: data.avatarProvider,
                backgroundColor: const Color(0xFFE2E8F0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  final String label;
  final String iconAsset;

  const _SportChip({required this.label, required this.iconAsset});

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

class _CommunityProfileBottomNavBar extends StatelessWidget {
  final VoidCallback onCommunityTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;

  const _CommunityProfileBottomNavBar({
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
