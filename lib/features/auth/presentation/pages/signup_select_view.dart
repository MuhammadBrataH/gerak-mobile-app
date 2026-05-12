import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/core/constants/signup_tokens.dart';

class SignUpSelectView extends StatelessWidget {
  const SignUpSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: signupBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: signupBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double cardWidth = maxWidth > 420 ? 360 : maxWidth - 32;
              final double verticalPadding = 24;

              return Stack(
                children: [
                  Positioned(
                    top: -88.4,
                    left: -71,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                        color: royalblue100,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -19.5,
                    bottom: -143.2,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                        color: deepskyblue,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: verticalPadding),
                      child: Center(
                        child: SizedBox(
                          width: cardWidth,
                          height: constraints.maxHeight - (verticalPadding * 2),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.center,
                            child: Container(
                              width: cardWidth,
                              padding: const EdgeInsets.symmetric(
                                horizontal: padding32,
                                vertical: 32,
                              ),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(32),
                                ),
                                color: white200,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1A0F172A),
                                    blurRadius: 24,
                                    offset: Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'GERAK',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w900,
                                      height: 1.11,
                                      letterSpacing: -1.8,
                                      color: royalblue200,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Pilih Jenis Akun',
                                    style: TextStyle(
                                      fontSize: fs30,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      letterSpacing: -0.75,
                                      color: gray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Akun Pribadi atau Akun Komunitas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Plus Jakarta Sans',
                                      height: 1.5,
                                      color: darkslategray,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 36),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      boxShadow: shadowDrop,
                                      gradient: gradient1,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br48),
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(AppRoutes.registerPrivate1);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        foregroundColor: white200,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(br48),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: padding16,
                                        ),
                                      ),
                                      child: const Text(
                                        'PRIBADI',
                                        style: TextStyle(
                                          fontSize: fs18,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w800,
                                          height: 1.56,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'atau',
                                    style: TextStyle(
                                      fontSize: fs30,
                                      fontFamily: 'Plus Jakarta Sans',
                                      height: 0.8,
                                      letterSpacing: -0.12,
                                      color: darkslategray,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      boxShadow: shadowDrop,
                                      gradient: gradient1,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br48),
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                          AppRoutes.registerCommunity1,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        foregroundColor: white200,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(br48),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: padding16,
                                        ),
                                      ),
                                      child: const Text(
                                        'KOMUNITAS',
                                        style: TextStyle(
                                          fontSize: fs18,
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.w800,
                                          height: 1.56,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: darkslategray,
                      tooltip: 'Kembali',
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
