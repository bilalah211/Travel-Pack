import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? disabledColor;
  final double elevation;
  final double borderRadius;
  final double? height;
  final double? width;
  final bool enabled;
  final TextStyle? textStyle;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFF1A237E),
    this.foregroundColor = Colors.white,
    this.disabledColor,
    this.elevation = 2,
    this.borderRadius = 12,
    this.height,
    this.width,
    this.enabled = true,
    this.textStyle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = enabled
        ? backgroundColor
        : disabledColor ?? Colors.grey[400]!;

    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      elevation: elevation,
      child: Container(
        height: height ?? 56,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            if (elevation > 0)
              BoxShadow(
                color: effectiveBackgroundColor.withValues(alpha: 0.3),
                blurRadius: elevation * 2,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: enabled && !isLoading ? onTap : null,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: foregroundColor.withValues(alpha: 0.2),
            highlightColor: foregroundColor.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null && !isLoading) ...[
                    icon!,
                    const SizedBox(width: 12),
                  ],
                  if (isLoading)
                    CircularProgressIndicator()
                  else
                    Text(title, style: textStyle),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
