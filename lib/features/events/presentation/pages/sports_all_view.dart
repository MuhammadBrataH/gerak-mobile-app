import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SportsAllView extends StatelessWidget {
  const SportsAllView({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = <_SportItemData>[
      _SportItemData(label: 'FOOTBALL', iconAsset: 'assets/icons/soccer.svg'),
      _SportItemData(label: 'FUTSAL', iconAsset: 'assets/icons/futsal.svg'),
      _SportItemData(
        label: 'MINI SOCCER',
        iconAsset: 'assets/icons/mini_soccer.svg',
      ),
      _SportItemData(
        label: 'BASKETBALL',
        iconAsset: 'assets/icons/basketball.svg',
      ),
      _SportItemData(
        label: 'BADMINTON',
        iconAsset: 'assets/icons/badminton.svg',
      ),
      _SportItemData(label: 'VOLLEY', iconAsset: 'assets/icons/volley.svg'),
      _SportItemData(label: 'RUNNING', iconAsset: 'assets/icons/run.svg'),
      _SportItemData(label: 'PADEL', iconAsset: 'assets/icons/padel.svg'),
      _SportItemData(label: 'BILLIARD', iconAsset: 'assets/icons/billiard.svg'),
      _SportItemData(label: 'CHESS', iconAsset: 'assets/icons/chess.svg'),
      _SportItemData(
        label: 'TABLE TENNIS',
        iconAsset: 'assets/icons/table_tennis.svg',
      ),
      _SportItemData(
        label: 'TENNIS FIELD',
        iconAsset: 'assets/icons/tennis_field.svg',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(title: 'SPORTS', onBackTap: () => Get.back()),
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
                  children: sports
                      .map((sport) => _SportChip(data: sport))
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

  const _TopBar({required this.title, required this.onBackTap});

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
        ],
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  final _SportItemData data;

  const _SportChip({required this.data});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF475569),
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
  final String iconAsset;

  const _SportItemData({required this.label, required this.iconAsset});
}
