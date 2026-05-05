import 'package:flutter/material.dart';

// Color design tokens
const Color aliceblue = Color(0xFFE2E8F0);
const Color darkslategray = Color(0xFF475569);
const Color deepskyblue = Color(0x0D0EA5E9);
const Color gray = Color(0xFF0F172A);
const Color royalblue100 = Color(0x0D2563EB);
const Color royalblue200 = Color(0xFF2563EB);
const Color white100 = Color(0x01FFFFFF);
const Color white200 = Color(0xFFFFFFFF);
const Color whitesmoke = Color(0xFFF8FAFC);
const Color signupBackground = Color(0xFFF1F5FF);

// Number design tokens
const double br10 = 10;
const double br32 = 32;
const double br48 = 48;
const double fs12 = 12;
const double fs16 = 16;
const double fs20 = 20;
const double fs30 = 30;
const double height16 = 16;
const double height60 = 60;
const double padding1 = 1;
const double padding4 = 4;
const double padding14 = 14;
const double padding15 = 15;
const double padding16 = 16;
const double padding32 = 32;
const double width294 = 294;

// BoxShadow design tokens
const List<BoxShadow> shadowDrop = [
  BoxShadow(
    color: Color(0x332563EB),
    blurRadius: 24,
    spreadRadius: 0,
    offset: Offset(0, 8),
  ),
];

// LinearGradient design tokens
const LinearGradient gradientPrimary = LinearGradient(
  transform: GradientRotation(3.14 * 0.28),
  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  stops: [0, 1],
);
