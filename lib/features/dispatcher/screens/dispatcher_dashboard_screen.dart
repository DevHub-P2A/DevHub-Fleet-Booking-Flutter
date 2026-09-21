import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/state/view_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/reservation_request_model.dart';
import '../providers/dispatcher_dashboard_provider.dart';
import '../widgets/dispatcher_stat_card.dart';
import '../widgets/pending_requests_table.dart';

class DispatcherDashboardScreen extends StatefulWidget {
  const DispatcherDashboardScreen({super.key});

  @override
  State<DispatcherDashboardScreen> createState() =>
      _DispatcherDashboardScreenState();
}

class _DispatcherDashboardScreenState extends State<DispatcherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fires after the first frame so the provider can safely notify listeners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DispatcherDashboardProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DispatcherDashboardProvider>();
    final bool mobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(mobile ? 16 : 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: _buildBody(context, provider, mobile),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DispatcherDashboardProvider provider,
    bool mobile,
  ) {
    // First load only — a refresh keeps the existing content on screen.
    if (provider.isLoading && !provider.hasRequests) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.hasError && !provider.hasRequests) {
      return _buildErrorState(provider);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Dispatcher Dashboard', style: AppTextStyles.pageTitle),

        const SizedBox(height: 20),

        _buildStatGrid(context, provider, mobile),

        const SizedBox(height: 24),

        PendingRequestsTable(
          requests: provider.pendingRequests,
          isMobile: mobile,
          isBusy: provider.isRequestBusy,
          onReview: (request) => _openReviewSheet(context, request),
          onViewAll: _openFullQueue,
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  // ============================================================
  // STAT GRID
  // ============================================================

  Widget _buildStatGrid(
    BuildContext context,
    DispatcherDashboardProvider provider,
    bool mobile,
  ) {
    final stats = provider.stats;

    final cards = <Widget>[
      DispatcherStatCard(
        label: 'Pending Requests',
        value: '${stats.pendingRequests}',
        icon: Icons.pending_actions_outlined,
        highlighted: true,
        onTap: _openFullQueue,
      ),
      DispatcherStatCard(
        label: 'Approved Today',
        value: '${stats.approvedToday}',
        icon: Icons.verified_outlined,
      ),
      DispatcherStatCard(
        label: 'Available Vehicles',
        value: '${stats.availableVehicles}',
        icon: Icons.local_taxi_outlined,
        iconColor: AppColors.success,
      ),
      DispatcherStatCard(
        label: 'Available Drivers',
        value: '${stats.availableDrivers}',
        icon: Icons.badge_outlined,
      ),
      DispatcherStatCard(
        label: 'Active Trips',
        value: '${stats.activeTrips}',
        icon: Icons.navigation_outlined,
        iconColor: AppColors.purple,
      ),
      DispatcherStatCard(
        label: 'Completed Trips',
        value: '${stats.completedTripsThisWeek}',
        caption: 'this week',
        icon: Icons.check_circle_outline,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        // 6 across on wide desktop, 3 on tablet, 2 on phone.
        final int columns = constraints.maxWidth >= 1150
            ? 6
            : constraints.maxWidth >= 760
            ? 3
            : 2;

        const double spacing = 14;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards)
              SizedBox(width: itemWidth, child: card),
          ],
        );
      },
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(DispatcherDashboardProvider provider) {
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
          ElevatedButton(
            onPressed: provider.load,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  /// Placeholder until the Reservation Requests queue screen exists — it will
  /// become `Navigator.pushNamed(context, AppRoutes.reservationRequests)`.
  void _openFullQueue() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservation Requests queue — coming next')),
    );
  }

  Future<void> _openReviewSheet(
    BuildContext context,
    ReservationRequestModel request,
  ) async {
    final provider = context.read<DispatcherDashboardProvider>();

    final RequestStatus? decision = await showModalBottomSheet<RequestStatus>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => _ReviewSheet(request: request),
    );

    if (decision == null || !mounted) return;

    final bool ok = await provider.reviewRequest(
      requestId: request.id,
      decision: decision,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? '#${request.id} ${decision.label.toLowerCase()}'
              : 'Could not update #${request.id}',
        ),
      ),
    );
  }
}

/// Lightweight approve/reject sheet. The full-page review flow with the
/// rejection-reason protocol lives on the Reservation Requests screen.
class _ReviewSheet extends StatelessWidget {
  final ReservationRequestModel request;

  const _ReviewSheet({required this.request});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('#${request.id}', style: AppTextStyles.mono),
          const SizedBox(height: 8),
          Text(request.requesterName, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          Text(
            '${request.department} • ${request.purpose}',
            style: AppTextStyles.caption,
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 16),

          _row(Icons.place_outlined, request.route),
          const SizedBox(height: 8),
          _row(
            Icons.people_outline,
            '${request.passengerCount} passengers • ${request.vehicleType}',
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(context, RequestStatus.rejected),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.dangerBorder),
                  ),
                  child: const Text('Reject'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pop(context, RequestStatus.approved),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                  ),
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textTertiary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: AppTextStyles.body)),
      ],
    );
  }
}
