import '../models/driver_dashboard_models.dart';

/// Contract for everything the Driver Dashboard needs. Swap in an API
/// implementation later without touching the provider or screen.
abstract class DriverRepository {
  Future<DriverDashboardStatsModel> fetchDashboardStats();
  Future<NextTripSummaryModel?> fetchNextTrip();
}

class MockDriverRepository implements DriverRepository {
  MockDriverRepository({this.latency = const Duration(milliseconds: 500)});

  final Duration latency;

  @override
  Future<DriverDashboardStatsModel> fetchDashboardStats() async {
    await Future<void>.delayed(latency);
    return const DriverDashboardStatsModel(
      todaysTrips: 1,
      activeTrips: 0,
      completedTrips: 12,
    );
  }

  @override
  Future<NextTripSummaryModel?> fetchNextTrip() async {
    await Future<void>.delayed(latency);
    final today = DateTime.now();
    return NextTripSummaryModel(
      assignmentId: 'TRP-8924',
      status: 'Upcoming',
      passengerName: 'Ahmed Mohamed',
      pickupLocation: 'Assiut Airport',
      destination: 'Downtown',
      scheduledAt: DateTime(today.year, today.month, today.day, 10, 30),
      reportingNote: 'Please report to vehicle 15 minutes before scheduled pickup.',
    );
  }
}
