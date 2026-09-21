import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared text styles. Use `.copyWith()` for one-off tweaks rather than
/// declaring a fresh `TextStyle` inside a widget.
class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle pageTitle = TextStyle(
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Small upper-case label above a metric, e.g. "PENDING REQUESTS".
  static const TextStyle cardLabel = TextStyle(
    fontSize: 10,
    height: 1.1,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  /// The big number on a stat card.
  static const TextStyle metric = TextStyle(
    fontSize: 26,
    height: 1.1,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 12,
    height: 1.3,
    color: AppColors.textBody,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 10,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  /// Monospace — used for IDs and plate numbers in the designs.
  static const TextStyle mono = TextStyle(
    fontSize: 11,
    height: 1.3,
    fontWeight: FontWeight.w700,
    fontFamily: 'monospace',
    color: AppColors.primary,
  );
}
