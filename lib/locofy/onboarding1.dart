import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/locofy/tokens.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Olahraga dengan Komunitas Terdekat',
      description:
          'Gunakan radar lokasi untuk menemukan jadwal olahraga dan komunitas yang ada di sekitarmu dengan cepat.',
      imageAsset: 'assets/onboarding1.jpeg',
    ),
    _OnboardingPageData(
      title: 'Cari Lawan &\nIsi Slot Kosong',
      description:
          'Kesulitan mencari sparring atau tim kekurangan pemain? Temukan semuanya di satu aplikasi.',
      imageAsset: 'assets/onboarding2.jpeg',
    ),
    _OnboardingPageData(
      title: 'Ayo kita GERAK',
      description:
          'Olahraga adalah investasi terbaik untuk kehidupanmu. Ayo kita olahraga bersama kita GERAK.',
      imageAsset: 'assets/onboarding3.jpeg',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentIndex >= _pages.length - 1) {
      Get.offAllNamed(AppRoutes.login);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _skipToEnd() {
    _controller.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: white300,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: white300,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                width: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, top: 6),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: _skipToEnd,
                          child: const Text(
                            'Lewati',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                              height: 2,
                              letterSpacing: -1.2,
                              color: royalblue200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _pages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return _OnboardingPage(
                            data: _pages[index],
                            currentIndex: _currentIndex,
                            totalPages: _pages.length,
                            onPrimaryAction: _goNext,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final String imageAsset;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onPrimaryAction;

  const _OnboardingPage({
    required this.data,
    required this.currentIndex,
    required this.totalPages,
    required this.onPrimaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double imageSize = width * 0.72;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 32,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -1.4,
              color: royalblue200,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: imageSize + 20,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 8,
                  child: Container(
                    width: width * 1.2,
                    height: imageSize * 0.7,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(9999)),
                      color: royalblue100,
                    ),
                  ),
                ),
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(br32)),
                    color: white300,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(br32)),
                    child: Image(
                      image: AssetImage(data.imageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Plus Jakarta Sans',
              height: 1.5,
              color: darkslategray,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalPages, (index) {
              final bool isActive = index == currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? royalblue200 : royalblue100,
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onPrimaryAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: royalblue200,
                foregroundColor: white300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(br20),
                ),
              ),
              child: Text(
                currentIndex == totalPages - 1 ? 'MULAI' : 'LANJUT',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
