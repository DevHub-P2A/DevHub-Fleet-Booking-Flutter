import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// One of the six counters across the top of the Dispatcher Dashboard.
///
/// [highlighted] renders the amber treatment the designs give to
/// "Pending Requests" — the card that needs action.
class DispatcherStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? caption;
  final IconData icon;
  final Color iconColor;
  final bool highlighted;
  final VoidCallback? onTap;

  const DispatcherStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
    this.iconColor = AppColors.primary,
    this.highlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color accent = highlighted ? AppColors.warning : iconColor;

    return Material(
      color: highlighted ? AppColors.warningSoft : AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: highlighted
                  ? AppColors.warningBorder
                  : AppColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardLabel.copyWith(
                        color: highlighted
                            ? AppColors.warning
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: highlighted
                          ? Colors.white
                          : AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(icon, size: 16, color: accent),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.metric.copyWith(
                  color: highlighted ? AppColors.warning : AppColors.textPrimary,
                ),
              ),

              if (caption != null) ...[
                const SizedBox(height: 4),
                Text(
                  caption!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
