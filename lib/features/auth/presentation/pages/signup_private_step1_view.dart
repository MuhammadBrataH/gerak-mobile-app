import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/core/constants/signup_tokens.dart';

class SignUpPrivateStep1View extends StatefulWidget {
  const SignUpPrivateStep1View({super.key});

  @override
  State<SignUpPrivateStep1View> createState() => _SignUpPrivateStep1ViewState();
}

class _SignUpPrivateStep1ViewState extends State<SignUpPrivateStep1View> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_firstNameController.text.trim().isEmpty) {
      Get.snackbar('Validasi', 'Nama depan wajib diisi');
      return;
    }
    Get.toNamed(AppRoutes.registerPrivate2);
  }

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
                              padding: const EdgeInsets.all(padding32),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(br32),
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
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                    'Selamat Datang',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w800,
                                      height: 1.2,
                                      letterSpacing: -0.75,
                                      color: gray,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Silahkan mendaftar untuk melanjutkan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Plus Jakarta Sans',
                                      height: 1.5,
                                      color: darkslategray,
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  _LabeledInput(
                                    label: 'Nama depan',
                                    controller: _firstNameController,
                                  ),
                                  const SizedBox(height: 16),
                                  _LabeledInput(
                                    label: 'Nama belakang (opsional)',
                                    controller: _lastNameController,
                                  ),
                                  const SizedBox(height: 28),
                                  Container(
                                    decoration: const BoxDecoration(
                                      boxShadow: shadowDrop,
                                      gradient: gradientPrimary,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br48),
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: _goNext,
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
                                        'LANJUT',
                                        style: TextStyle(
                                          fontSize: 18,
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

class _LabeledInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _LabeledInput({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: fs12,
            fontFamily: 'Plus Jakarta Sans',
            height: 1.33,
            letterSpacing: 1.2,
            color: darkslategray,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br10)),
            ),
            fillColor: whitesmoke,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

