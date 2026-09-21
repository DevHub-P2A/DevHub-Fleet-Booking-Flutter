/// The three counters at the top of the Driver Dashboard.
class DriverDashboardStatsModel {
  final int todaysTrips;
  final int activeTrips;
  final int completedTrips;

  const DriverDashboardStatsModel({
    required this.todaysTrips,
    required this.activeTrips,
    required this.completedTrips,
  });

  const DriverDashboardStatsModel.empty()
    : todaysTrips = 0,
      activeTrips = 0,
      completedTrips = 0;

  factory DriverDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DriverDashboardStatsModel(
      todaysTrips: json['todays_trips'] as int? ?? 0,
      activeTrips: json['active_trips'] as int? ?? 0,
      completedTrips: json['completed_trips'] as int? ?? 0,
    );
  }
}

/// The "Next Trip" card. Deliberately a slimmer shape than
/// `DriverTripModel` (used by the full trip screen) — the dashboard only
/// needs a preview, not live telematics.
class NextTripSummaryModel {
  final String assignmentId;
  final String status;
  final String passengerName;
  final String pickupLocation;
  final String destination;
  final DateTime scheduledAt;
  final String reportingNote;

  const NextTripSummaryModel({
    required this.assignmentId,
    required this.status,
    required this.passengerName,
    required this.pickupLocation,
    required this.destination,
    required this.scheduledAt,
    required this.reportingNote,
  });

  factory NextTripSummaryModel.fromJson(Map<String, dynamic> json) {
    return NextTripSummaryModel(
      assignmentId: json['assignment_id'] as String,
      status: json['status'] as String? ?? 'Upcoming',
      passengerName: json['passenger_name'] as String? ?? '',
      pickupLocation: json['pickup_location'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      scheduledAt:
          DateTime.tryParse(json['scheduled_at'] as String? ?? '') ??
          DateTime.now(),
      reportingNote: json['reporting_note'] as String? ?? '',
    );
  }
}
