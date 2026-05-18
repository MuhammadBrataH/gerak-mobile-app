import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class CommunityProfileView extends StatefulWidget {
  const CommunityProfileView({super.key});

  @override
  State<CommunityProfileView> createState() => _CommunityProfileViewState();
}

class _CommunityProfileViewState extends State<CommunityProfileView> {
  int _selectedTab = 0; // 0 = Postingan, 1 = Pertandingan

  // Data dari arguments
  late final String communityName;
  late final String badgeUrl;
  late final String categories;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    communityName = args['name'] as String? ?? 'PLAYMAKER FUN CLUB';
    badgeUrl = args['badgeUrl'] as String? ?? 'assets/sample 1.jpg';
    categories = args['categories'] as String? ?? 'FOOTBALL â€¢ PADEL';
  }

  void _showToast(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  Future<void> _openMoreSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      enableDrag: true,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: SafeArea(
                  top: false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 48,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _ActionItem(
                            icon: Icons.share_outlined,
                            label: 'Bagikan',
                            onTap: () => Get.back(),
                          ),
                          _ActionItem(
                            icon: Icons.group_outlined,
                            label: 'Lihat Anggota',
                            onTap: () => Get.back(),
                          ),
                          _ActionItem(
                            icon: Icons.notifications_outlined,
                            label: 'Kelola Notifikasi',
                            onTap: () => Get.back(),
                          ),
                          _ActionItem(
                            icon: Icons.report_gmailerrorred_outlined,
                            label: 'Laporkan Grup',
                            onTap: () => Get.back(),
                          ),
                          _ActionItem(
                            icon: Icons.logout,
                            label: 'Keluar Grup',
                            onTap: () => Get.back(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CommunityHeader(
                        communityName: communityName,
                        badgeUrl: badgeUrl,
                        onBackTap: () => Get.back(),
                        onProfileTap: () => _showToast('Profile avatar tapped'),
                        onMoreTap: _openMoreSheet,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _ProfileTabs(
                          activeIndex: _selectedTab,
                          onTabChanged: (index) {
                            setState(() => _selectedTab = index);
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
                  sliver: _selectedTab == 0
                      ? _buildPostinganList()
                      : _buildPertandinganList(),
                ),
              ],
            ),

            // â”€â”€ Bottom Nav Bar â”€â”€
            _CommunityProfileBottomNavBar(
              onCommunityTap: () => Get.offAllNamed(AppRoutes.community),
              onHomeTap: () => Get.offAllNamed(AppRoutes.dashboard),
              onProfileTap: () => Get.offAllNamed(AppRoutes.profile),
            ),
          ],
        ),
      ),
    );
  }

  // â”€â”€ Daftar Postingan (dummy data) â”€â”€
  Widget _buildPostinganList() {
    final posts = [
      _PostData(
        communityName: communityName,
        avatarUrl: badgeUrl,
        timeAgo: '1 minggu yang lalu',
        content: 'Lorem Ipsum anjing babi bajingan keparat',
        imageUrl: 'assets/sample 1.jpg',
        hasReadMore: false,
      ),
      _PostData(
        communityName: communityName,
        avatarUrl: badgeUrl,
        timeAgo: '1 minggu yang lalu',
        content:
            'Lorem Ipsum anjing babi bajingan keparat asd\nasdasdasdad, banyak asd',
        imageUrl: 'assets/sample 1.jpg',
        hasReadMore: true,
      ),
    ];

    return SliverList.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PostCard(data: posts[index]),
        );
      },
    );
  }

  // â”€â”€ Daftar Pertandingan (dummy data) â”€â”€
  Widget _buildPertandinganList() {
    final matches = [
      _MatchData(
        sportLabel: 'FOOTBALL',
        title: 'GIMMICK LEAGUE\nWEEK 3',
        dateTime: 'TODAY,  20:00',
        location: 'CIJERAH SOCCER ARENA',
        avatarUrl: badgeUrl,
      ),
      _MatchData(
        sportLabel: 'FOOTBALL',
        title: 'GIMMICK LEAGUE\nWEEK 3',
        dateTime: 'TODAY,  20:00',
        location: 'CIJERAH SOCCER ARENA',
        avatarUrl: badgeUrl,
      ),
      _MatchData(
        sportLabel: 'FOOTBALL',
        title: 'GIMMICK LEAGUE\nWEEK 3',
        dateTime: 'TODAY,  20:00',
        location: 'CIJERAH SOCCER ARENA',
        avatarUrl: badgeUrl,
      ),
    ];

    return SliverList.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MatchCard(data: matches[index]),
        );
      },
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// HEADER
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class _CommunityHeader extends StatelessWidget {
  final String communityName;
  final String badgeUrl;
  final VoidCallback onBackTap;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreTap;

  const _CommunityHeader({
    required this.communityName,
    required this.badgeUrl,
    required this.onBackTap,
    required this.onProfileTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Color(0xFF9199A5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Top Bar (back + avatar) â”€â”€
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              border: const Border(
                bottom: BorderSide(width: 1, color: Color(0x7FE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: onBackTap,
                  icon: const Icon(Icons.arrow_back, size: 24),
                ),
                const Spacer(),
                // Notification & more icons area
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 22,
                    color: Color(0xFF475569),
                  ),
                ),
                IconButton(
                  onPressed: onMoreTap,
                  icon: const Icon(
                    Icons.more_horiz,
                    size: 22,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: const Color(0x332563EB),
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/sample 1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // â”€â”€ Avatar Komunitas â”€â”€
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: CircleAvatar(
              radius: 72,
              backgroundImage: AssetImage(badgeUrl),
            ),
          ),

          // â”€â”€ Nama Komunitas â”€â”€
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Text(
              communityName,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 36,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w800,
                height: 1.11,
                letterSpacing: -1.80,
              ),
            ),
          ),

          // â”€â”€ EST. Year â”€â”€
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text(
              'EST. 2019',
              style: TextStyle(
                color: Color(0xFF0EA5E9),
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.43,
                letterSpacing: 0.35,
              ),
            ),
          ),

          // â”€â”€ Bio / Deskripsi â”€â”€
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Text(
              '#NambahBugarBukanCedera\nKomunitas Sepak Bola Fun Bandung\nOpen Public, Newbie Friendly',
              style: TextStyle(
                color: Color(0xCC0F172A),
                fontSize: 16,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.63,
              ),
            ),
          ),

          // â”€â”€ Sport Chips â”€â”€
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _SportChip(
                  label: 'BASKET',
                  iconPath: 'assets/icons/basketball.svg',
                ),
                _SportChip(
                  label: 'BADMINTON',
                  iconPath: 'assets/icons/badminton.svg',
                ),
                _SportChip(label: 'LARI', iconPath: 'assets/icons/run.svg'),
              ],
            ),
          ),

          // â”€â”€ Member Count â”€â”€
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
            child: Row(
              children: const [
                Text(
                  '500',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 24,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w800,
                    height: 1.5,
                    letterSpacing: -0.75,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'Members',
                  style: TextStyle(
                    color: Color(0xCC0F172A),
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF0F172A)
                  : const Color(0xFF475569),
              fontSize: 12,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w800,
              height: 1.5,
              letterSpacing: -0.75,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: label.length * 7.0,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTabs extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const _ProfileTabs({required this.activeIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'POSTINGAN',
              isSelected: activeIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          Expanded(
            child: _TabItem(
              label: 'PERTANDINGAN',
              isSelected: activeIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// SPORT CHIP
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class _SportChip extends StatelessWidget {
  final String label;
  final String iconPath;

  const _SportChip({required this.label, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF475569),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 16,
            height: 16,
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
              letterSpacing: -0.60,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: const Color(0xFFF1F5F9),
        child: Icon(icon, size: 18, color: const Color(0xFF0F172A)),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// POSTINGAN CARD
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class _PostData {
  final String communityName;
  final String avatarUrl;
  final String timeAgo;
  final String content;
  final String imageUrl;
  final bool hasReadMore;

  const _PostData({
    required this.communityName,
    required this.avatarUrl,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.hasReadMore,
  });
}

class _PostCard extends StatelessWidget {
  final _PostData data;

  const _PostCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Avatar + Nama + Waktu â”€â”€
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundImage: AssetImage(data.avatarUrl),
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
                      height: 1.5,
                    ),
                  ),
                  Text(
                    data.timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w500,
                      height: 1.67,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // â”€â”€ Konten teks â”€â”€
          if (data.hasReadMore)
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
                      height: 1.42,
                    ),
                  ),
                  const TextSpan(
                    text: '...Baca selengkapnya',
                    style: TextStyle(
                      color: Color(0xFF696969),
                      fontSize: 12,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              data.content,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 12,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w400,
                height: 1.42,
              ),
            ),
          const SizedBox(height: 10),

          // â”€â”€ Gambar dengan gradient overlay â”€â”€
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                Image.asset(
                  data.imageUrl,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.5, 1.0),
                        end: const Alignment(0.5, 0.0),
                        colors: [
                          Colors.black.withValues(alpha: 0.40),
                          Colors.black.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// PERTANDINGAN (MATCH) CARD
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class _MatchData {
  final String sportLabel;
  final String title;
  final String dateTime;
  final String location;
  final String avatarUrl;

  const _MatchData({
    required this.sportLabel,
    required this.title,
    required this.dateTime,
    required this.location,
    required this.avatarUrl,
  });
}

class _MatchCard extends StatelessWidget {
  final _MatchData data;

  const _MatchCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          width: 1,
          color: Colors.black.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // â”€â”€ Sport label (icon + text) â”€â”€
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/soccer.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF2563EB),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.sportLabel,
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
          const SizedBox(height: 12),

          // â”€â”€ Title + Avatar â”€â”€
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 30,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(data.avatarUrl),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // â”€â”€ Date & Location â”€â”€
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Color(0xFF475569)),
              const SizedBox(width: 8),
              Text(
                data.dateTime,
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
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Color(0xFF475569),
              ),
              const SizedBox(width: 8),
              Text(
                data.location,
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
        ],
      ),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// BOTTOM NAV BAR
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

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

