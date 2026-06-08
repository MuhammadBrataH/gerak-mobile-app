import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';

class SportsAllView extends StatefulWidget {
  const SportsAllView({super.key});

  @override
  State<SportsAllView> createState() => _SportsAllViewState();
}

class _SportsAllViewState extends State<SportsAllView> {
  late final List<_SportItemData> _sports;
  EventController get _eventController => Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    _sports = const <_SportItemData>[
      _SportItemData(
        label: 'FOOTBALL',
        key: 'football',
        iconAsset: 'assets/icons/soccer.svg',
      ),
      _SportItemData(
        label: 'FUTSAL',
        key: 'futsal',
        iconAsset: 'assets/icons/futsal.svg',
      ),
      _SportItemData(
        label: 'MINI SOCCER',
        key: 'mini_soccer',
        iconAsset: 'assets/icons/mini_soccer.svg',
      ),
      _SportItemData(
        label: 'BASKETBALL',
        key: 'basketball',
        iconAsset: 'assets/icons/basketball.svg',
      ),
      _SportItemData(
        label: 'BADMINTON',
        key: 'badminton',
        iconAsset: 'assets/icons/badminton.svg',
      ),
      _SportItemData(
        label: 'VOLLEY',
        key: 'volleyball',
        iconAsset: 'assets/icons/volley.svg',
      ),
      _SportItemData(
        label: 'RUNNING',
        key: 'running',
        iconAsset: 'assets/icons/run.svg',
      ),
      _SportItemData(
        label: 'PADEL',
        key: 'padel',
        iconAsset: 'assets/icons/padel.svg',
      ),
      _SportItemData(
        label: 'BILLIARD',
        key: 'billiard',
        iconAsset: 'assets/icons/billiard.svg',
      ),
      _SportItemData(
        label: 'CHESS',
        key: 'chess',
        iconAsset: 'assets/icons/chess.svg',
      ),
      _SportItemData(
        label: 'TABLE TENNIS',
        key: 'table_tennis',
        iconAsset: 'assets/icons/table_tennis.svg',
      ),
      _SportItemData(
        label: 'TENNIS FIELD',
        key: 'tennis',
        iconAsset: 'assets/icons/tennis_field.svg',
      ),
    ];
  }

  void _toggleSelection(String sportKey) {
    _eventController.toggleSportSelection(sportKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(
              title: 'SPORTS',
              onBackTap: () => Get.back(),
              onSaveTap: () => Get.back(),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Pilih olahraga untuk jelajahi komunitas dan event.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _sports
                      .map(
                        (sport) => Obx(
                          () => _SportChip(
                            data: sport,
                            isSelected: _eventController.currentSports.contains(
                              sport.key,
                            ),
                            onTap: () => _toggleSelection(sport.key),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBackTap;
  final VoidCallback onSaveTap;

  const _TopBar({
    required this.title,
    required this.onBackTap,
    required this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBackTap,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: onSaveTap,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2563EB),
              textStyle: const TextStyle(
                fontSize: 14,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
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

class _SportChip extends StatelessWidget {
  final _SportItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportChip({
    required this.data,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : const Color(0xFF475569),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                data.iconAsset,
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFFAFBFF),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                data.label,
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
  }
}

class _SportItemData {
  final String label;
  final String key;
  final String iconAsset;

  const _SportItemData({
    required this.label,
    required this.key,
    required this.iconAsset,
  });
}
