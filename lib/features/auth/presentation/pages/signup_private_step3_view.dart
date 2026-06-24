import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/constants/signup_tokens.dart';
import 'package:gerak_mobile_app/core/utils/snackbar_helper.dart';
import '../controllers/auth_controller.dart';

class SignUpPrivateStep3View extends StatefulWidget {
  const SignUpPrivateStep3View({super.key});

  @override
  State<SignUpPrivateStep3View> createState() => _SignUpPrivateStep3ViewState();
}

class _SignUpPrivateStep3ViewState extends State<SignUpPrivateStep3View> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isFromGoogle = false;

  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool _isAllowedEmailDomain(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@gmail.com') ||
        lower.endsWith('@googlemail.com') ||
        lower.endsWith('@polban.ac.id');
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    final controller = Get.find<AuthController>();
    final email = controller.signupEmail.value;
    if (email != null && email.isNotEmpty) {
      _emailController.text = email;
      _isFromGoogle = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final controller = Get.find<AuthController>();
    final name = controller.signupName.value?.trim() ?? '';
    final gender = controller.signupGender.value;
    final dateOfBirth = controller.signupDateOfBirth.value;
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final accountType = controller.accountType;

    setState(() {
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    bool hasError = false;

    if (name.isEmpty) {
      showCustomSnackbar('Validasi', 'Nama belum diisi');
      return;
    }
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email wajib diisi';
      });
      hasError = true;
    } else {
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      if (!emailRegex.hasMatch(email)) {
        setState(() {
          _emailError = 'Format email tidak valid';
        });
        hasError = true;
      } else if (!_isAllowedEmailDomain(email)) {
        setState(() {
          _emailError = 'Gunakan email yang valid';
        });
        hasError = true;
      }
    }

    if (phone.isEmpty) {
      setState(() {
        _phoneError = 'Nomor telepon wajib diisi';
      });
      hasError = true;
    }

    if (password.isEmpty || confirm.isEmpty) {
      setState(() {
        if (password.isEmpty) {
          _passwordError = 'password dan konfirmasi password harus diisi';
        }
        if (confirm.isEmpty) {
          _confirmPasswordError = 'password dan konfirmasi password harus diisi';
        }
      });
      hasError = true;
    } else {
      final isLengthFailed = password.length < 8;
      final isNumberFailed = !password.contains(RegExp(r'[0-9]'));
      final isCapitalFailed = !password.contains(RegExp(r'[A-Z]'));

      final failedRulesCount = (isLengthFailed ? 1 : 0) + (isNumberFailed ? 1 : 0) + (isCapitalFailed ? 1 : 0);

      if (failedRulesCount > 1) {
        setState(() {
          _passwordError = 'format password tidak sesuai';
        });
        hasError = true;
      } else if (isLengthFailed) {
        setState(() {
          _passwordError = 'password harus terdiri dari 8 char';
        });
        hasError = true;
      } else if (isNumberFailed) {
        setState(() {
          _passwordError = 'password harus ada angka';
        });
        hasError = true;
      } else if (isCapitalFailed) {
        setState(() {
          _passwordError = 'harus ada minimal 1 huruf kapital';
        });
        hasError = true;
      }

      if (!hasError && password != confirm) {
        setState(() {
          _confirmPasswordError = 'Konfirmasi password tidak sama';
        });
        hasError = true;
      }
    }

    if (hasError) return;

    controller.register(
      email,
      password,
      name,
      phone,
      gender,
      dateOfBirth,
      accountType: accountType,
    );
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
                      child: SingleChildScrollView(
                        child: Center(
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
                                readOnly: _isFromGoogle,
                                errorText: _emailError,
                              ),
                              const SizedBox(height: 16),
                              _LabeledInput(
                                label: 'Nomor Telepon',
                                controller: _phoneController,
                                errorText: _phoneError,
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
                                errorText: _passwordError,
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
                                errorText: _confirmPasswordError,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '*Password must be at least 8 characters, contain uppercase, lowercase, and a number',
                                style: TextStyle(
                                  fontSize: fs12,
                                  fontFamily: 'Plus Jakarta Sans',
                                  height: 1.5,
                                  letterSpacing: 0.6,
                                  color: darkslategray,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: shadowDrop,
                                  gradient: gradientPrimary,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(br48),
                                  ),
                                ),
                                child: Obx(() {
                                  final controller = Get.find<AuthController>();
                                  return ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : _submit,
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
                                    child: Text(
                                      controller.isLoading.value
                                          ? 'Loading...'
                                          : 'DAFTAR',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.w800,
                                        height: 1.56,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
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
  final bool readOnly;
  final String? errorText;

  const _LabeledInput({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.onToggleVisibility,
    this.readOnly = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

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
          readOnly: readOnly,
          enableInteractiveSelection: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: hasError ? const Color(0xFFDC2626) : aliceblue,
              ),
              borderRadius: BorderRadius.all(Radius.circular(br10)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: hasError ? const Color(0xFFDC2626) : aliceblue,
              ),
              borderRadius: BorderRadius.all(Radius.circular(br10)),
            ),
            fillColor: readOnly ? Colors.grey.shade200 : whitesmoke,
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
        if (hasError) ...[
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.error,
                color: Color(0xFFDC2626),
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  errorText!,
                  style: const TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
