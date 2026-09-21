import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/vehicle_assignment_provider.dart';
import '../widgets/fleet_vehicle_card.dart';

class VehicleAssignmentScreen extends StatefulWidget {
  const VehicleAssignmentScreen({super.key});

  @override
  State<VehicleAssignmentScreen> createState() =>
      _VehicleAssignmentScreenState();
}

class _VehicleAssignmentScreenState extends State<VehicleAssignmentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleAssignmentProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleAssignmentProvider>();
    final bool mobile = MediaQuery.of(context).size.width < 700;

    if (provider.isLoading && provider.request == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 120),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.hasError && provider.request == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 40, color: AppColors.textTertiary),
            const SizedBox(height: 14),
            Text(provider.errorMessage ?? 'Something went wrong.', style: AppTextStyles.body),
            const SizedBox(height: 18),
            ElevatedButton(onPressed: provider.load, child: const Text('Try again')),
          ],
        ),
      );
    }

    final request = provider.request!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(mobile ? 16 : 28).copyWith(bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Vehicle Assignment', style: AppTextStyles.pageTitle),
              const SizedBox(height: 18),
              _buildReservationSummary(request, mobile),
              const SizedBox(height: 24),
              const Text('Available Fleet Vehicles', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 14),
              _buildFilterBar(provider, mobile),
              const SizedBox(height: 16),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 28),
            child: _buildVehicleGrid(provider),
          ),
        ),

        _buildFooterBar(context, provider, mobile),
      ],
    );
  }

  // ============================================================
  // RESERVATION SUMMARY
  // ============================================================

  Widget _buildReservationSummary(dynamic request, bool mobile) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.infoSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primarySoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Approved Reservation Summary', style: AppTextStyles.bodyStrong),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '#${request.id}',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.primarySoft),
          const SizedBox(height: 14),
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: [
              _summaryField('REQUESTER', request.requesterName, icon: Icons.person_outline),
              _summaryField('ROUTE & DESTINATION', request.destination, icon: Icons.place_outlined),
              _summaryField('SCHEDULE', _formatDate(request.scheduledAt), icon: Icons.schedule),
              _summaryField(
                'CAPACITY REQUIREMENT',
                '${request.passengerCount} Passengers',
                icon: Icons.people_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryField(String label, String value, {required IconData icon}) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.tableHeader),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(child: Text(value, style: AppTextStyles.bodyStrong)),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER BAR
  // ============================================================

  Widget _buildFilterBar(VehicleAssignmentProvider provider, bool mobile) {
    final requiredSeats = provider.request?.passengerCount ?? 0;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: mobile ? double.infinity : 260,
          child: TextField(
            onChanged: provider.setSearchQuery,
            decoration: const InputDecoration(
              isDense: true,
              hintText: 'Search license plate, driver name, vehicle model...',
              prefixIcon: Icon(Icons.search, size: 18),
            ),
          ),
        ),

        _seatChip('All', 0, provider),
        _seatChip('4+', 4, provider),
        _seatChip(
          requiredSeats > 0 && requiredSeats != 4 && requiredSeats != 8 && requiredSeats != 12
              ? '$requiredSeats+ (Req)'
              : '${requiredSeats > 0 ? requiredSeats : 6}+',
          requiredSeats > 0 ? requiredSeats : 6,
          provider,
        ),
        _seatChip('8+', 8, provider),
        _seatChip('12+', 12, provider),

        FilterChip(
          label: const Text('Available Only'),
          selected: provider.availableOnly,
          onSelected: provider.setAvailableOnly,
          selectedColor: AppColors.primarySoft,
          checkmarkColor: AppColors.primary,
          labelStyle: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: provider.availableOnly ? AppColors.primary : AppColors.textBody,
          ),
        ),
      ],
    );
  }

  Widget _seatChip(String label, int seats, VehicleAssignmentProvider provider) {
    final bool selected = provider.minSeats == seats;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => provider.setMinSeats(seats),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: selected ? Colors.white : AppColors.textBody,
      ),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.borderStrong),
    );
  }

  // ============================================================
  // VEHICLE GRID
  // ============================================================

  Widget _buildVehicleGrid(VehicleAssignmentProvider provider) {
    final vehicles = provider.filteredVehicles;

    if (vehicles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Text('No vehicles match these filters.', style: AppTextStyles.body),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final int columns = constraints.maxWidth >= 1100
            ? 4
            : constraints.maxWidth >= 760
            ? 2
            : 1;
        const double spacing = 16;
        final double itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final vehicle in vehicles)
                SizedBox(
                  width: itemWidth,
                  child: FleetVehicleCard(
                    vehicle: vehicle,
                    isSelected: provider.selectedVehicleId == vehicle.id,
                    onTap: () => provider.selectVehicle(vehicle.id),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooterBar(
    BuildContext context,
    VehicleAssignmentProvider provider,
    bool mobile,
  ) {
    final selected = provider.selectedVehicle;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: mobile ? 16 : 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 10,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_car, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SELECTED VEHICLE', style: AppTextStyles.tableHeader),
                  Text(
                    selected?.name ?? 'None selected',
                    style: AppTextStyles.bodyStrong,
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: provider.load,
                child: const Text('Change Selection'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: selected == null || provider.isConfirming
                    ? null
                    : () => _onConfirm(context, provider),
                icon: provider.isConfirming
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_forward, size: 15),
                iconAlignment: IconAlignment.end,
                label: const Text('Confirm Vehicle & Proceed to Driver Assignment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _onConfirm(
    BuildContext context,
    VehicleAssignmentProvider provider,
  ) async {
    final bool ok = await provider.confirmAssignment();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Vehicle confirmed — Driver Assignment is next on the build list.'
              : 'Could not confirm the assignment.',
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
