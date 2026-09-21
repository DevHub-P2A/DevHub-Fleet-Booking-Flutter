import 'package:flutter/material.dart';

import '../models/reservation_model.dart';
import '../widgets/summary_card.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final List<ReservationModel> reservations = [
    ReservationModel(
      id: 'RES-4091',
      vehicleId: 'VH-001',
      vehicleName: 'Toyota Hiace Commuter',
      plateNumber: 'UCF-8820',
      pickupDate: DateTime(2025, 9, 20, 9, 0),
      returnDate: DateTime(2025, 9, 20, 17, 0),
      status: 'Confirmed',
      totalPrice: 14,
    ),
    ReservationModel(
      id: 'RES-4087',
      vehicleId: 'VH-002',
      vehicleName: 'Toyota Camry',
      plateNumber: 'CAM-1024',
      pickupDate: DateTime(2025, 9, 21, 10, 0),
      returnDate: DateTime(2025, 9, 21, 16, 0),
      status: 'Pending',
      totalPrice: 10,
    ),
    ReservationModel(
      id: 'RES-4062',
      vehicleId: 'VH-003',
      vehicleName: 'Hyundai Tucson',
      plateNumber: 'TUC-5531',
      pickupDate: DateTime(2025, 9, 18, 8, 0),
      returnDate: DateTime(2025, 9, 18, 18, 0),
      status: 'Completed',
      totalPrice: 16,
    ),
  ];

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  int get confirmedCount {
    return reservations
        .where((reservation) => reservation.status == 'Confirmed')
        .length;
  }

  int get pendingCount {
    return reservations
        .where((reservation) => reservation.status == 'Pending')
        .length;
  }

  int get completedCount {
    return reservations
        .where((reservation) => reservation.status == 'Completed')
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 20),

              _buildSummary(),

              const SizedBox(height: 24),

              _buildHistorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Reservations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xff182230),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'View and manage your vehicle reservations',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSummary() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns;

        if (width >= 900) {
          columns = 4;
        } else if (width >= 500) {
          columns = 2;
        } else {
          columns = 1;
        }

        const spacing = 10.0;

        final cardWidth = (width - (columns - 1) * spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: SummaryCard(
                title: 'Total Reservations',
                value: '${reservations.length}',
                subtitle: 'All reservations',
                icon: Icons.calendar_month_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: SummaryCard(
                title: 'Confirmed',
                value: '$confirmedCount',
                subtitle: 'Approved bookings',
                icon: Icons.check_circle_outline,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: SummaryCard(
                title: 'Pending',
                value: '$pendingCount',
                subtitle: 'Awaiting approval',
                icon: Icons.schedule_outlined,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: SummaryCard(
                title: 'Completed',
                value: '$completedCount',
                subtitle: 'Finished trips',
                icon: Icons.task_alt_outlined,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffd9deeb)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reservation History',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xff182230),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Your recent vehicle reservations',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 16),

          if (reservations.isEmpty)
            _buildEmptyState()
          else
            ...reservations.map((reservation) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildReservationCard(reservation),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildReservationCard(ReservationModel reservation) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xfffafbfc),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe4e7ec)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 650) {
            return _buildMobileReservationCard(reservation);
          }

          return _buildDesktopReservationCard(reservation);
        },
      ),
    );
  }

  Widget _buildDesktopReservationCard(ReservationModel reservation) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVehicleIcon(),

        const SizedBox(width: 12),

        Expanded(flex: 3, child: _buildVehicleInfo(reservation)),

        const SizedBox(width: 20),

        Expanded(flex: 2, child: _buildDateInfo(reservation)),

        const SizedBox(width: 20),

        Expanded(child: _buildStatusInfo(reservation)),

        const SizedBox(width: 20),

        _buildPriceInfo(reservation),
      ],
    );
  }

  Widget _buildMobileReservationCard(ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildVehicleIcon(),

            const SizedBox(width: 10),

            Expanded(child: _buildVehicleInfo(reservation)),

            _buildStatusBadge(reservation.status),
          ],
        ),

        const SizedBox(height: 14),

        _buildDateInfo(reservation),

        const SizedBox(height: 12),

        Row(
          children: [
            const Text(
              'Total',
              style: TextStyle(fontSize: 10, color: Color(0xff667085)),
            ),
            const Spacer(),
            _buildPriceInfo(reservation),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleIcon() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xffeef4ff),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.directions_car_outlined,
        size: 22,
        color: Color(0xff2864e8),
      ),
    );
  }

  Widget _buildVehicleInfo(ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          reservation.vehicleName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xff182230),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          reservation.plateNumber,
          style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
        ),

        const SizedBox(height: 4),

        Text(
          reservation.id,
          style: const TextStyle(fontSize: 9, color: Color(0xff98a2b3)),
        ),
      ],
    );
  }

  Widget _buildDateInfo(ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservation Dates',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xff344054),
          ),
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 13,
              color: Color(0xff667085),
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                '${_formatDate(reservation.pickupDate)} '
                '${_formatTime(reservation.pickupDate)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(
              Icons.event_available_outlined,
              size: 13,
              color: Color(0xff667085),
            ),

            const SizedBox(width: 5),

            Expanded(
              child: Text(
                '${_formatDate(reservation.returnDate)} '
                '${_formatTime(reservation.returnDate)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: Color(0xff667085)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusInfo(ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xff344054),
          ),
        ),

        const SizedBox(height: 6),

        _buildStatusBadge(reservation.status),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case 'Confirmed':
        backgroundColor = const Color(0xffecfdf3);
        textColor = const Color(0xff027a48);
        break;

      case 'Pending':
        backgroundColor = const Color(0xfffffaeb);
        textColor = const Color(0xffb54708);
        break;

      case 'Completed':
        backgroundColor = const Color(0xfff2f4f7);
        textColor = const Color(0xff475467);
        break;

      default:
        backgroundColor = const Color(0xfff2f4f7);
        textColor = const Color(0xff475467);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildPriceInfo(ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'Total',
          style: TextStyle(fontSize: 9, color: Color(0xff667085)),
        ),

        const SizedBox(height: 3),

        Text(
          '\$${reservation.totalPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xff182230),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 35),
      child: const Column(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 40,
            color: Color(0xff98a2b3),
          ),
          SizedBox(height: 10),
          Text(
            'No reservations yet',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xff344054),
            ),
          ),
        ],
      ),
    );
  }
}
