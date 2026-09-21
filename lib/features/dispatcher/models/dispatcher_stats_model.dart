/// The six counters across the top of the Dispatcher Dashboard.
class DispatcherStatsModel {
  final int pendingRequests;
  final int approvedToday;
  final int availableVehicles;
  final int availableDrivers;
  final int activeTrips;
  final int completedTripsThisWeek;

  const DispatcherStatsModel({
    required this.pendingRequests,
    required this.approvedToday,
    required this.availableVehicles,
    required this.availableDrivers,
    required this.activeTrips,
    required this.completedTripsThisWeek,
  });

  const DispatcherStatsModel.empty()
    : pendingRequests = 0,
      approvedToday = 0,
      availableVehicles = 0,
      availableDrivers = 0,
      activeTrips = 0,
      completedTripsThisWeek = 0;

  DispatcherStatsModel copyWith({
    int? pendingRequests,
    int? approvedToday,
    int? availableVehicles,
    int? availableDrivers,
    int? activeTrips,
    int? completedTripsThisWeek,
  }) {
    return DispatcherStatsModel(
      pendingRequests: pendingRequests ?? this.pendingRequests,
      approvedToday: approvedToday ?? this.approvedToday,
      availableVehicles: availableVehicles ?? this.availableVehicles,
      availableDrivers: availableDrivers ?? this.availableDrivers,
      activeTrips: activeTrips ?? this.activeTrips,
      completedTripsThisWeek:
          completedTripsThisWeek ?? this.completedTripsThisWeek,
    );
  }

  factory DispatcherStatsModel.fromJson(Map<String, dynamic> json) {
    return DispatcherStatsModel(
      pendingRequests: json['pending_requests'] as int? ?? 0,
      approvedToday: json['approved_today'] as int? ?? 0,
      availableVehicles: json['available_vehicles'] as int? ?? 0,
      availableDrivers: json['available_drivers'] as int? ?? 0,
      activeTrips: json['active_trips'] as int? ?? 0,
      completedTripsThisWeek: json['completed_trips_week'] as int? ?? 0,
    );
  }
}
