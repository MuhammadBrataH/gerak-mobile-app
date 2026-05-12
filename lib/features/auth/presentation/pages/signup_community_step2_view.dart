import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gerak_mobile_app/core/routes/app_routes.dart';
import 'package:gerak_mobile_app/core/constants/signup_tokens.dart';

class SignUpCommunityStep2View extends StatefulWidget {
  const SignUpCommunityStep2View({super.key});

  @override
  State<SignUpCommunityStep2View> createState() => _SignUpCommunityStep2ViewState();
}

class _SignUpCommunityStep2ViewState extends State<SignUpCommunityStep2View> {
  String _month = 'Desember';
  String _day = '10';
  String _year = '2006';

  static const List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

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
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Tanggal Didirikan',
                                    style: TextStyle(
                                      fontSize: fs12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      height: 1.33,
                                      letterSpacing: 1.2,
                                      color: darkslategray,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: _DateBox(
                                          initialValue: _day,
                                          onChanged: (value) {
                                            _day = value;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 4,
                                        child: DropdownButtonFormField<String>(
                                          value: _month,
                                          isExpanded: true,
                                          items: _months
                                              .map(
                                                (month) => DropdownMenuItem(
                                                  value: month,
                                                  child: Text(
                                                    month,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value == null) {
                                              return;
                                            }
                                            setState(() {
                                              _month = value;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: aliceblue,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(br10),
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 1,
                                                color: aliceblue,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(br10),
                                              ),
                                            ),
                                            fillColor: whitesmoke,
                                            filled: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 12,
                                                ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: fs16,
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: darkslategray,
                                          ),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 3,
                                        child: _DateBox(
                                          initialValue: _year,
                                          onChanged: (value) {
                                            _year = value;
                                          },
                                        ),
                                      ),
                                    ],
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
                                      onPressed: () {
                                        Get.offAllNamed(AppRoutes.login);
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

class _DateBox extends StatelessWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _DateBox({required this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: aliceblue),
          borderRadius: BorderRadius.all(Radius.circular(br10)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: aliceblue),
          borderRadius: BorderRadius.all(Radius.circular(br10)),
        ),
        fillColor: whitesmoke,
        filled: true,
        hintText: initialValue,
        hintStyle: const TextStyle(
          fontSize: fs20,
          fontFamily: 'Plus Jakarta Sans',
          color: darkslategray,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 12,
        ),
      ),
      style: const TextStyle(
        fontSize: fs20,
        fontFamily: 'Plus Jakarta Sans',
        color: darkslategray,
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: onChanged,
      textAlign: TextAlign.center,
    );
  }
}

