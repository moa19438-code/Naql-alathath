import 'package:flutter/material.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';

enum AppButtonVariant { primary, secondary, ghost }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final AppButtonVariant variant;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.variant = AppButtonVariant.primary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final btnStyle = switch (variant) {
      AppButtonVariant.primary => ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      AppButtonVariant.secondary => OutlinedButton.styleFrom(
          foregroundColor: cs.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          side: BorderSide(color: cs.primary.withOpacity(0.35)),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      AppButtonVariant.ghost => TextButton.styleFrom(
          foregroundColor: cs.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
        ),
    };

    final child = loading
        ? SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary ? cs.onPrimary : cs.primary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 10),
              ],
              Text(text),
            ],
          );

    return SizedBox(
      width: double.infinity,
      child: switch (variant) {
        AppButtonVariant.primary => ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: btnStyle,
            child: child,
          ),
        AppButtonVariant.secondary => OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: btnStyle,
            child: child,
          ),
        AppButtonVariant.ghost => TextButton(
            onPressed: loading ? null : onPressed,
            style: btnStyle,
            child: child,
          ),
      },
    );
  }
}
