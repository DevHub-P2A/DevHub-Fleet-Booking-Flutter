import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_pill.dart';
import '../models/fleet_vehicle_model.dart';

class FleetVehicleCard extends StatelessWidget {
  final FleetVehicleModel vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const FleetVehicleCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = !vehicle.isSelectable;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSelected)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Current Selection',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(vehicle.bayLocation, style: AppTextStyles.caption),
                  ],
                ),

              if (isSelected) const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      vehicle.name,
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 14),
                    ),
                  ),
                  _statusPillFor(vehicle.status),
                ],
              ),

              const SizedBox(height: 12),

              _statRow(
                Icons.event_seat_outlined,
                'Capacity',
                '${vehicle.seatCapacity} Seats',
                trailing: vehicle.meetsSeatRequirement ? null : '(Needs more)',
                trailingIsWarning: !vehicle.meetsSeatRequirement,
              ),
              const SizedBox(height: 8),
              _statRow(
                Icons.ev_station_outlined,
                vehicle.energyLabel,
                vehicle.rangeKm != null
                    ? '${vehicle.energyPercent}% (${vehicle.rangeKm} km range)'
                    : '${vehicle.energyPercent}%',
              ),

              const SizedBox(height: 10),
              Text(
                'Odometer  ${_formatKm(vehicle.odometerKm)} km',
                style: AppTextStyles.caption,
              ),

              if (vehicle.noteText != null) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: vehicle.noteIsWarning
                        ? (vehicle.status == VehicleAssignmentStatus.maintenance
                              ? AppColors.dangerSoft
                              : AppColors.warningSoft)
                        : AppColors.successSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        vehicle.noteIsWarning
                            ? (vehicle.status ==
                                      VehicleAssignmentStatus.maintenance
                                  ? Icons.build_outlined
                                  : Icons.warning_amber_outlined)
                            : Icons.check_circle_outline,
                        size: 14,
                        color: vehicle.noteIsWarning
                            ? (vehicle.status ==
                                      VehicleAssignmentStatus.maintenance
                                  ? AppColors.danger
                                  : AppColors.warning)
                            : AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          vehicle.noteText!,
                          style: TextStyle(
                            fontSize: 10.5,
                            height: 1.3,
                            color: vehicle.noteIsWarning
                                ? (vehicle.status ==
                                          VehicleAssignmentStatus.maintenance
                                      ? AppColors.danger
                                      : AppColors.warning)
                                : AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (vehicle.inspectionComplete) ...[
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Daily Pre-Trip Inspection Complete',
                      style: TextStyle(fontSize: 10.5, color: AppColors.success),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: disabled
                    ? OutlinedButton(
                        onPressed: null,
                        child: Text(
                          vehicle.status == VehicleAssignmentStatus.maintenance
                              ? 'In Maintenance Shop'
                              : 'Unavailable for this Trip',
                        ),
                      )
                    : isSelected
                    ? ElevatedButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.check, size: 15),
                        label: const Text('Selected Vehicle'),
                      )
                    : OutlinedButton(
                        onPressed: onTap,
                        child: const Text('Select Vehicle'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusPillFor(VehicleAssignmentStatus status) {
    return switch (status) {
      VehicleAssignmentStatus.available => StatusPill.success(status.label),
      VehicleAssignmentStatus.conflict => StatusPill.warning(status.label),
      VehicleAssignmentStatus.maintenance => StatusPill.danger(status.label),
    };
  }

  Widget _statRow(
    IconData icon,
    String label,
    String value, {
    String? trailing,
    bool trailingIsWarning = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 7),
        Text(label, style: AppTextStyles.caption),
        const SizedBox(width: 6),
        Expanded(
          child: Wrap(
            spacing: 4,
            children: [
              Text(value, style: AppTextStyles.bodyStrong.copyWith(fontSize: 11)),
              if (trailing != null)
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: trailingIsWarning
                        ? AppColors.danger
                        : AppColors.textTertiary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatKm(int km) {
    final s = km.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i != 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }
}
