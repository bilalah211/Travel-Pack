import 'package:flutter/material.dart';
import 'package:travel_pack/utils/constants/app_assets.dart';

class CustomOutlineButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String? image; // make optional
  final bool showImage; // new flag
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final double elevation;

  const CustomOutlineButton({
    super.key,
    required this.title,
    required this.onTap,
    this.image,
    this.showImage = true, // default: show image
    this.borderColor = Colors.grey,
    this.textColor = Colors.grey,
    this.borderRadius = 12,
    this.height,
    this.width,
    this.backgroundColor,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          if (elevation > 0)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: elevation,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.grey.withValues(alpha: 0.1),
          highlightColor: Colors.grey.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showImage && image != null && image!.isNotEmpty) ...[
                  Image.asset(image!, fit: BoxFit.cover, height: 25),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
