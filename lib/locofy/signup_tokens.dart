import 'package:flutter/material.dart';

// Color design tokens
const Color darkslategray = Color(0xFF475569);
const Color deepskyblue = Color(0x0D0EA5E9);
const Color gray = Color(0xFF0F172A);
const Color royalblue100 = Color(0x0D2563EB);
const Color royalblue200 = Color(0xFF2563EB);
const Color white100 = Color(0x01FFFFFF);
const Color white200 = Color(0xFFFFFFFF);
const Color signupBackground = Color(0xFFF1F5FF);

// Number design tokens
const double br48 = 48;
const double fs18 = 18;
const double fs30 = 30;
const double height60 = 60;
const double padding16 = 16;
const double padding32 = 32;

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
const LinearGradient gradient1 = LinearGradient(
  transform: GradientRotation(3.14 * 0.28),
  colors: [Color(0xFF3B82F6), royalblue200],
  stops: [0, 1],
);
