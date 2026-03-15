import 'dart:ui';

class OnboardingModel {
  final String title;
  final String subTitle;
  final String image;
  final Color? colors;

  OnboardingModel({
    this.colors,
    required this.title,
    required this.subTitle,
    required this.image,
  });
}
