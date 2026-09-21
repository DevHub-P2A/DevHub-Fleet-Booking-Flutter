import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The coloured capsule used for every status in the designs
/// (Pending / Confirmed / Available / Maintenance / Cancelled ...).
///
/// Construct it with one of the named factories so colours stay consistent
/// instead of being re-picked screen by screen.
class StatusPill extends StatelessWidget {
  final String label;
  final Color foreground;
  final Color background;
  final Color borderColor;
  final bool showDot;

  const StatusPill({
    super.key,
    required this.label,
    required this.foreground,
    required this.background,
    required this.borderColor,
    this.showDot = true,
  });

  factory StatusPill.success(String label, {bool showDot = true}) => StatusPill(
    label: label,
    foreground: AppColors.success,
    background: AppColors.successSoft,
    borderColor: AppColors.successBorder,
    showDot: showDot,
  );

  factory StatusPill.warning(String label, {bool showDot = true}) => StatusPill(
    label: label,
    foreground: AppColors.warning,
    background: AppColors.warningSoft,
    borderColor: AppColors.warningBorder,
    showDot: showDot,
  );

  factory StatusPill.danger(String label, {bool showDot = true}) => StatusPill(
    label: label,
    foreground: AppColors.danger,
    background: AppColors.dangerSoft,
    borderColor: AppColors.dangerBorder,
    showDot: showDot,
  );

  factory StatusPill.info(String label, {bool showDot = true}) => StatusPill(
    label: label,
    foreground: AppColors.primary,
    background: AppColors.infoSoft,
    borderColor: AppColors.primarySoft,
    showDot: showDot,
  );

  factory StatusPill.neutral(String label, {bool showDot = false}) =>
      StatusPill(
        label: label,
        foreground: AppColors.neutral,
        background: AppColors.neutralSoft,
        borderColor: AppColors.neutralBorder,
        showDot: showDot,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: foreground,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              height: 1.2,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
