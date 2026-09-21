import '../models/dispatcher_profile_model.dart';
import '../models/dispatcher_stats_model.dart';
import '../models/reservation_request_model.dart';

/// The contract the UI talks to. Nothing above this line knows whether the
/// data came from memory or from your server.
///
/// When the backend is ready: write `ApiDispatcherRepository implements
/// DispatcherRepository`, swap the one line in `main.dart`, delete the mock.
/// No screen or provider changes.
abstract class DispatcherRepository {
  Future<DispatcherStatsModel> fetchStats();

  /// [limit] mirrors the dashboard, which shows only the first few rows and
  /// links to the full queue.
  Future<List<ReservationRequestModel>> fetchPendingRequests({int? limit});

  Future<ReservationRequestModel> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? rejectionReason,
  });

  Future<DispatcherProfileModel> fetchProfile();
}

/// In-memory implementation backed by the seed data below.
///
/// The artificial delay is deliberate: it keeps the loading states honest so
/// they don't break the day the real network latency shows up.
class MockDispatcherRepository implements DispatcherRepository {
  MockDispatcherRepository({this.latency = const Duration(milliseconds: 600)});

  final Duration latency;

  final List<ReservationRequestModel> _requests = _seedRequests();

  DispatcherStatsModel _stats = const DispatcherStatsModel(
    pendingRequests: 7,
    approvedToday: 12,
    availableVehicles: 18,
    availableDrivers: 14,
    activeTrips: 5,
    completedTripsThisWeek: 28,
  );

  @override
  Future<DispatcherStatsModel> fetchStats() async {
    await Future<void>.delayed(latency);
    return _stats;
  }

  @override
  Future<List<ReservationRequestModel>> fetchPendingRequests({
    int? limit,
  }) async {
    await Future<void>.delayed(latency);

    final pending = _requests
        .where((request) => request.status == RequestStatus.pending)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    if (limit == null || limit >= pending.length) return pending;
    return pending.sublist(0, limit);
  }

  @override
  Future<ReservationRequestModel> updateRequestStatus({
    required String requestId,
    required RequestStatus status,
    String? rejectionReason,
  }) async {
    await Future<void>.delayed(latency);

    final index = _requests.indexWhere((request) => request.id == requestId);
    if (index == -1) {
      throw StateError('Request $requestId not found');
    }

    final updated = _requests[index].copyWith(status: status);
    _requests[index] = updated;

    // Keep the counters consistent with the list the user is looking at.
    _stats = _stats.copyWith(
      pendingRequests: (_stats.pendingRequests - 1).clamp(0, 999),
      approvedToday: status == RequestStatus.approved
          ? _stats.approvedToday + 1
          : _stats.approvedToday,
    );

    return updated;
  }

  @override
  Future<DispatcherProfileModel> fetchProfile() async {
    await Future<void>.delayed(latency);
    return const DispatcherProfileModel(
      fullName: 'David Hassan',
      email: 'd.hassan@campus.edu',
      phoneNumber: '+1 (555) 019-4471',
      employeeId: 'DSP-2210',
      department: 'Campus Transit Hub • Evaluation Queue',
      shift: 'Day Shift (08:00 - 16:30)',
    );
  }

  // ============================================================
  // SEED DATA — mirrors the design files
  // ============================================================

  static List<ReservationRequestModel> _seedRequests() {
    final today = DateTime.now();
    DateTime at(int addDays, int hour, int minute) =>
        DateTime(today.year, today.month, today.day + addDays, hour, minute);

    return [
      ReservationRequestModel(
        id: 'REQ-1042',
        requesterName: 'Dr. Sarah Jenkins',
        department: 'Dept. of Biology',
        origin: 'Central Campus',
        destination: 'Pine Ridge Station',
        scheduledAt: at(0, 8, 30),
        passengerCount: 4,
        vehicleType: 'Passenger Van',
        purpose: 'Field Research & Soil Ecology',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 2)),
      ),
      ReservationRequestModel(
        id: 'REQ-1043',
        requesterName: 'Prof. Marcus Vance',
        department: 'Architecture Dept.',
        origin: 'Engineering Annex',
        destination: 'East Reservoir Dam',
        scheduledAt: at(0, 10, 15),
        passengerCount: 8,
        vehicleType: 'Passenger Van',
        purpose: 'Site Survey: New Science Lab',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 4)),
      ),
      ReservationRequestModel(
        id: 'REQ-1044',
        requesterName: 'Dean Laura Sterling',
        department: 'Administration',
        origin: 'Administration Hall',
        destination: 'Regional Airport (MHT)',
        scheduledAt: at(0, 13, 45),
        passengerCount: 2,
        vehicleType: 'Sedan',
        purpose: 'Board of Trustees pickup',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 6)),
      ),
      ReservationRequestModel(
        id: 'REQ-1045',
        requesterName: 'Coach Brian Delgado',
        department: 'Athletics',
        origin: 'Athletics Complex',
        destination: 'State Arena Fieldhouse',
        scheduledAt: at(1, 6, 0),
        passengerCount: 14,
        vehicleType: 'Campus Bus',
        purpose: 'Away fixture — varsity squad',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 9)),
      ),
      ReservationRequestModel(
        id: 'REQ-1046',
        requesterName: 'Dr. Linda Kim',
        department: 'Chemistry',
        origin: 'South Gate Terminal',
        destination: 'Metropolitan Metro',
        scheduledAt: at(1, 13, 0),
        passengerCount: 18,
        vehicleType: 'Campus Bus',
        purpose: 'Regional conference shuttles',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 20)),
      ),
      ReservationRequestModel(
        id: 'REQ-1047',
        requesterName: 'Prof. Elena Rostova',
        department: 'Geology',
        origin: 'Science Complex',
        destination: 'Mountain Spur Quarry',
        scheduledAt: at(2, 7, 30),
        passengerCount: 6,
        vehicleType: 'Passenger Van',
        purpose: 'Core sampling trip',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 26)),
      ),
      ReservationRequestModel(
        id: 'REQ-1048',
        requesterName: 'Dean Gregory Hall',
        department: 'School of Law',
        origin: 'Law Hall',
        destination: 'Downtown Court',
        scheduledAt: at(2, 9, 15),
        passengerCount: 3,
        vehicleType: 'Sedan',
        purpose: 'Moot court observation',
        status: RequestStatus.pending,
        submittedAt: today.subtract(const Duration(hours: 31)),
      ),
    ];
  }
}
