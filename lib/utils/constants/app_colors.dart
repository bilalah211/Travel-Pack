import 'package:flutter/material.dart';

class AppColors {
  // 🌞 Light Mode
  static const Color primary = Color(0xFF2B7DE9);
  static const Color secondaryBlue = Color(0xFFA9D6FF);
  static const Color accent = Color(0xFFF4A261);
  static const Color success = Color(0xFF2ECC71);
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8F9FB);
  static const Color textPrimary = Color(0xFF1E1E1E);
  static const Color textSecondary = Color(0xFF707070);
  static const Color divider = Color(0xFFE0E0E0);

  // 🌙 Dark Mode
  static const Color darkPrimary = Color(0xFF1E66D0);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1F1F1F);
  static const Color darkAccent = Color(0xFFE76F51);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF2A2A2A);

  // 🌈 Gradients
  static const LinearGradient blueSkyGradient = LinearGradient(
    colors: [Color(0xFFA9D6FF), Color(0xFFE1F5FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFFB84C), Color(0xFFFFE29D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
