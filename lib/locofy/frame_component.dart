import 'package:flutter/material.dart';
import 'package:gerak_mobile_app/locofy/tokens.dart';

class FrameComponent extends StatelessWidget {
  const FrameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const SizedBox(width: 380.5, height: 355.8),
        Positioned(
          top: 155.8,
          left: 27,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: white100,
              foregroundColor: white300,
              padding: EdgeInsets.zero,
              fixedSize: const Size(width336, height70),
              minimumSize: const Size(336, 70),
              elevation: 0,
            ),
            child: const Text(
              'LANJUT',
              style: TextStyle(
                fontSize: fs26,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w800,
                height: 1.08,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: -19.5,
          child: Stack(
            children: [
              const SizedBox(width: 400, height: 400, child: SizedBox()),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(9999)),
                    color: deepskyblue,
                  ),
                ),
              ),
              const Positioned(
                top: 114.3,
                left: 186.5,
                child: SizedBox(
                  width: 47,
                  height: height8,
                  child: Image(
                    image: AssetImage('assets/Indikator@2x.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
