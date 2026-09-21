import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/status_pill.dart';
import '../models/driver_dashboard_models.dart';
import '../providers/driver_dashboard_provider.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverDashboardProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DriverDashboardProvider>();
    final bool mobile = MediaQuery.of(context).size.width < 700;

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(mobile ? 16 : 28),
        child: _buildBody(provider, mobile),
      ),
    );
  }

  Widget _buildBody(DriverDashboardProvider provider, bool mobile) {
    if (provider.isLoading && !provider.hasNextTrip) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.hasError && !provider.hasNextTrip) {
      return _buildErrorState(provider);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dashboard', style: AppTextStyles.pageTitle),
        const SizedBox(height: 20),
        _buildStatRow(provider.stats, mobile),
        const SizedBox(height: 20),
        if (provider.hasNextTrip)
          _buildNextTripCard(provider.nextTrip!)
        else
          _buildNoTripState(),
      ],
    );
  }

  // ============================================================
  // STAT ROW
  // ============================================================

  Widget _buildStatRow(DriverDashboardStatsModel stats, bool mobile) {
    final cards = [
      _StatCardData(
        label: "Today's Trips",
        value: '${stats.todaysTrips}',
        caption: 'Trip scheduled today',
        icon: Icons.calendar_today_outlined,
        iconColor: AppColors.primary,
        iconBg: AppColors.primarySoft,
      ),
      _StatCardData(
        label: 'Active Trip',
        value: '${stats.activeTrips}',
        caption: 'Currently active',
        icon: Icons.location_on_outlined,
        iconColor: AppColors.success,
        iconBg: AppColors.successSoft,
      ),
      _StatCardData(
        label: 'Completed Trips',
        value: '${stats.completedTrips}',
        caption: 'Total completed',
        icon: Icons.sync_alt,
        iconColor: AppColors.purple,
        iconBg: AppColors.primarySoft,
      ),
    ];

    if (mobile) {
      return Column(
        children: [
          for (final card in cards) ...[
            _buildStatCard(card),
            const SizedBox(height: 12),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: _buildStatCard(cards[i])),
          if (i != cards.length - 1) const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildStatCard(_StatCardData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.label, style: AppTextStyles.body),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: data.iconBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(data.icon, size: 19, color: data.iconColor),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            data.value,
            style: AppTextStyles.metric.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 4),
          Text(data.caption, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  // ============================================================
  // NEXT TRIP
  // ============================================================

  Widget _buildNextTripCard(NextTripSummaryModel trip) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              const Text('Next Trip', style: AppTextStyles.sectionTitle),
              StatusPill.warning(trip.status),
              const Spacer(),
              Text(
                'Assignment ID: #${trip.assignmentId}',
                style: AppTextStyles.caption,
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, constraints) {
              final bool wide = constraints.maxWidth > 560;

              final fields = [
                _tripField(
                  'PASSENGER',
                  trip.passengerName,
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.neutralSoft,
                    child: Text(
                      _initials(trip.passengerName),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBody,
                      ),
                    ),
                  ),
                ),
                _tripField(
                  'PICKUP',
                  trip.pickupLocation,
                  dotColor: AppColors.primary,
                ),
                _tripField(
                  'DESTINATION',
                  trip.destination,
                  dotColor: AppColors.success,
                ),
                _tripField(
                  'TIME',
                  _formatTime(trip.scheduledAt),
                  icon: Icons.access_time,
                ),
              ];

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < fields.length; i++) ...[
                      Expanded(child: fields[i]),
                      if (i != fields.length - 1) const SizedBox(width: 12),
                    ],
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final field in fields) ...[
                    field,
                    const SizedBox(height: 14),
                  ],
                ],
              );
            },
          ),

          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 18),

          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 15,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        trip.reportingNote,
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Full trip view — see "My Trip" tab'),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward, size: 15),
                iconAlignment: IconAlignment.end,
                label: const Text('View Trip'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tripField(
    String label,
    String value, {
    Widget? leading,
    Color? dotColor,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTextStyles.tableHeader),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 8)],
            if (dotColor != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyStrong,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY / ERROR
  // ============================================================

  Widget _buildNoTripState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 34,
            color: AppColors.textTertiary,
          ),
          SizedBox(height: 12),
          Text('No upcoming trip', style: AppTextStyles.bodyStrong),
          SizedBox(height: 4),
          Text(
            "You're all clear — nothing scheduled next.",
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(DriverDashboardProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            size: 40,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 14),
          Text(
            provider.errorMessage ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 18),
          ElevatedButton(onPressed: provider.load, child: const Text('Try again')),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  String _formatTime(DateTime date) {
    final int hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour < 12 ? 'AM' : 'PM';
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const _StatCardData({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });
}
