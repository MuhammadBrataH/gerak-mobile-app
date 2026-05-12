import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/core/constants/signup_tokens.dart';

class SignUpPrivateStep3View extends StatefulWidget {
  const SignUpPrivateStep3View({super.key});

  @override
  State<SignUpPrivateStep3View> createState() => _SignUpPrivateStep3ViewState();
}

class _SignUpPrivateStep3ViewState extends State<SignUpPrivateStep3View> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty) {
      Get.snackbar('Validasi', 'Email wajib diisi');
      return;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar('Validasi', 'Format email tidak valid');
      return;
    }
    if (password.isEmpty || confirm.isEmpty) {
      Get.snackbar('Validasi', 'Password dan konfirmasi wajib diisi');
      return;
    }
    if (password != confirm) {
      Get.snackbar('Validasi', 'Konfirmasi password tidak sama');
      return;
    }
    Get.offAllNamed(AppRoutes.login);
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
                                    label: 'Email',
                                    controller: _emailController,
                                  ),
                                  const SizedBox(height: 16),
                                  _LabeledInput(
                                    label: 'Password',
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  _LabeledInput(
                                    label: 'Konfirmasi Password',
                                    controller: _confirmPasswordController,
                                    obscureText: !_showConfirmPassword,
                                    onToggleVisibility: () {
                                      setState(() {
                                        _showConfirmPassword =
                                            !_showConfirmPassword;
                                      });
                                    },
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
                                      onPressed: _submit,
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
                                        'DAFTAR',
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
  final bool obscureText;
  final VoidCallback? onToggleVisibility;

  const _LabeledInput({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.onToggleVisibility,
  });

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
          obscureText: obscureText,
          decoration: InputDecoration(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: onToggleVisibility == null
                ? null
                : IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: darkslategray,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

