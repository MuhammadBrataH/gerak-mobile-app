import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/features/auth/controllers/auth_controller.dart';
import 'package:gerak_mobile_app/locofy/login_tokens.dart';

class LoginLocofy extends StatefulWidget {
  const LoginLocofy({super.key});

  @override
  State<LoginLocofy> createState() => _LoginLocofyState();
}

class _LoginLocofyState extends State<LoginLocofy> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: loginBackground,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: loginBackground,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double maxWidth = constraints.maxWidth;
              final double cardWidth = maxWidth > 420 ? 360 : maxWidth - 32;

              final double verticalPadding = 24;

              return Stack(
                children: [
                  Positioned(
                    left: -19.5,
                    bottom: -44.2,
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                        color: deepskyblue,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -88.4,
                    left: -71,
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(9999)),
                        color: royalblue200,
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
                              padding: const EdgeInsets.all(32),
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
                                children: [
                                  const Text(
                                    'GERAK',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w900,
                                      height: 1.11,
                                      letterSpacing: -1.8,
                                      color: royalblue100,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: gap40),
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
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Masuk ke akun GERAK kamu',
                                    style: TextStyle(
                                      fontSize: fs16,
                                      fontFamily: 'Plus Jakarta Sans',
                                      height: 1.5,
                                      color: darkslategray200,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: gap40),
                                  _LabeledField(
                                    label: 'USERNAME',
                                    hintText: 'muhammadbrata06@gmail.com',
                                    controller: _emailController,
                                  ),
                                  const SizedBox(height: 24),
                                  _PasswordField(
                                    controller: _passwordController,
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x332563EB),
                                          blurRadius: 24,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                        transform: GradientRotation(
                                          3.14 * 0.28,
                                        ),
                                        colors: [
                                          Color(0xFF3B82F6),
                                          Color(0xFF2563EB),
                                        ],
                                        stops: [0, 1],
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(br48),
                                      ),
                                    ),
                                    child: Obx(
                                      () => ElevatedButton(
                                        onPressed: controller.isLoading.value
                                            ? null
                                            : () {
                                                controller.login(
                                                  _emailController.text.trim(),
                                                  _passwordController.text,
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
                                            vertical: 16,
                                          ),
                                        ),
                                        child: Text(
                                          controller.isLoading.value
                                              ? 'LOADING...'
                                              : 'MASUK',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Lexend',
                                            fontWeight: FontWeight.w800,
                                            height: 1.56,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Divider(
                                          color: aliceblue,
                                          height: 1,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          'OR CONNECT WITH',
                                          style: const TextStyle(
                                            fontSize: fs10,
                                            fontFamily: 'Plus Jakarta Sans',
                                            height: 1.5,
                                            letterSpacing: 3,
                                            color: darkslategray200,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Divider(
                                          color: aliceblue,
                                          height: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    height: 46,
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.g_mobiledata,
                                        size: 22,
                                        color: darkslategray200,
                                      ),
                                      label: const Text(
                                        'GOOGLE',
                                        style: TextStyle(
                                          fontSize: fs12,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w700,
                                          height: 1.33,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: darkslategray200,
                                        backgroundColor: white200,
                                        side: const BorderSide(
                                          width: 1,
                                          color: aliceblue,
                                        ),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(br48),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 22,
                                          vertical: padding12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: height20),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      const Text(
                                        'Don\'t have an account yet? ',
                                        style: TextStyle(
                                          fontSize: fs14,
                                          fontFamily: 'Plus Jakarta Sans',
                                          height: 1.43,
                                          color: darkslategray200,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.register);
                                        },
                                        borderRadius: BorderRadius.circular(6),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          child: Text(
                                            'Create Account',
                                            style: TextStyle(
                                              fontSize: fs14,
                                              fontFamily: 'Plus Jakarta Sans',
                                              fontWeight: FontWeight.w700,
                                              height: 1.43,
                                              color: royalblue100,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _LabeledField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;

  const _LabeledField({
    required this.label,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: padding4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: fs12,
              fontFamily: 'Plus Jakarta Sans',
              height: 1.33,
              letterSpacing: 1.2,
              color: darkslategray200,
            ),
          ),
        ),
        const SizedBox(height: 4.5),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontSize: fs16,
            fontFamily: 'Plus Jakarta Sans',
            color: darkslategray100,
          ),
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br32)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br32)),
            ),
            fillColor: whitesmoke,
            filled: true,
            hintStyle: const TextStyle(
              fontSize: fs16,
              fontFamily: 'Plus Jakarta Sans',
              color: darkslategray100,
            ),
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'PASSWORD',
                style: TextStyle(
                  fontSize: fs12,
                  fontFamily: 'Plus Jakarta Sans',
                  height: 1.33,
                  letterSpacing: 1.2,
                  color: darkslategray200,
                ),
              ),
              Text(
                'FORGOT?',
                style: TextStyle(
                  fontSize: fs10,
                  fontFamily: 'Plus Jakarta Sans',
                  height: 1.5,
                  letterSpacing: 1,
                  color: royalblue100,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: widget.controller,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: fs16,
            fontFamily: 'Plus Jakarta Sans',
            color: darkslategray100,
          ),
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br32)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: aliceblue),
              borderRadius: BorderRadius.all(Radius.circular(br32)),
            ),
            fillColor: whitesmoke,
            filled: true,
            hintStyle: const TextStyle(
              fontSize: fs16,
              fontFamily: 'Plus Jakarta Sans',
              color: darkslategray100,
            ),
            hintText: '••••••••',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              onPressed: _toggleVisibility,
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: darkslategray100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
