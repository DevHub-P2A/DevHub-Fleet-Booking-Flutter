import '../../dispatcher/models/reservation_request_model.dart';
import '../models/admin_profile_model.dart';
import '../models/fleet_vehicle_model.dart';

/// Contract for everything the Admin role needs.
///
/// [ReservationRequestModel] is reused from the dispatcher feature on
/// purpose — a vehicle assignment always happens *against* an approved
/// request, so the two roles should share one model rather than each
/// keeping their own copy that can drift out of sync.
abstract class AdminRepository {
  Future<AdminProfileModel> fetchProfile();

  /// The approved request a vehicle is being assigned to, plus the fleet
  /// vehicles considered for it (with per-request availability/conflicts).
  Future<({ReservationRequestModel request, List<FleetVehicleModel> vehicles})>
  fetchAssignmentContext(String requestId);

  Future<void> confirmAssignment({
    required String requestId,
    required String vehicleId,
  });
}

class MockAdminRepository implements AdminRepository {
  MockAdminRepository({this.latency = const Duration(milliseconds: 600)});

  final Duration latency;

  @override
  Future<AdminProfileModel> fetchProfile() async {
    await Future<void>.delayed(latency);
    return AdminProfileModel(
      fullName: 'Ahmed Hassan',
      email: 'admin@fleetflow.com',
      phoneNumber: '+1 (555) 019-2834',
      role: 'Fleet Administrator',
      location: 'East Logistics Terminal',
      accountStatus: 'Active',
      operationalNote: 'Full operational authority over vehicle allocations and telemetry',
      securityClearance: 'Super Admin / Level 4',
      securityNote: 'Privileged access tier for system configuration and campus dispatch overrides',
      lastLoginAt: DateTime.now().subtract(const Duration(hours: 3)),
      lastLoginLocation: 'Central Campus Dispatch Station 1',
    );
  }

  @override
  Future<({ReservationRequestModel request, List<FleetVehicleModel> vehicles})>
  fetchAssignmentContext(String requestId) async {
    await Future<void>.delayed(latency);

    final today = DateTime.now();
    final request = ReservationRequestModel(
      id: requestId,
      requesterName: 'Dr. Sarah Jenkins',
      department: 'Dept. of Biology',
      origin: 'Central Campus',
      destination: 'Pine Ridge Field Station',
      scheduledAt: DateTime(today.year, today.month, today.day, 8, 30),
      passengerCount: 4,
      vehicleType: 'Passenger Van',
      purpose: 'Field Research & Soil Ecology',
      status: RequestStatus.approved,
      submittedAt: today.subtract(const Duration(hours: 5)),
    );

    final vehicles = <FleetVehicleModel>[
      const FleetVehicleModel(
        id: 'VAN-204',
        name: 'Toyota Hiace Commuter',
        type: 'Passenger Van',
        bayLocation: 'Bay 4B',
        status: VehicleAssignmentStatus.available,
        seatCapacity: 12,
        meetsSeatRequirement: true,
        energyLabel: 'Diesel Level',
        energyPercent: 88,
        rangeKm: 490,
        odometerKm: 34566,
        inspectionComplete: true,
        noteText: 'Maintenance: Up to date (Inspection valid)',
        noteIsWarning: false,
      ),
      const FleetVehicleModel(
        id: 'VAN-118',
        name: 'Ford Transit 350-HD',
        type: 'Passenger Van',
        bayLocation: 'Bay 2A',
        status: VehicleAssignmentStatus.available,
        seatCapacity: 15,
        meetsSeatRequirement: true,
        energyLabel: 'Fuel Level',
        energyPercent: 74,
        rangeKm: 380,
        odometerKm: 58110,
        inspectionComplete: true,
      ),
      const FleetVehicleModel(
        id: 'CAR-301',
        name: 'Chevrolet Malibu Hybrid',
        type: 'Sedan',
        bayLocation: 'Bay 1C',
        status: VehicleAssignmentStatus.conflict,
        seatCapacity: 5,
        meetsSeatRequirement: false,
        energyLabel: 'Battery & Fuel',
        energyPercent: 92,
        odometerKm: 19420,
        noteText: 'Overlapping reservation #REQ-1039 until 11:30 AM today.',
        noteIsWarning: true,
      ),
      const FleetVehicleModel(
        id: 'BUS-105',
        name: 'Blue Bird Campus Shuttle',
        type: 'Campus Bus',
        bayLocation: 'Central Transport Hub',
        status: VehicleAssignmentStatus.maintenance,
        seatCapacity: 24,
        meetsSeatRequirement: true,
        energyLabel: 'Battery',
        energyPercent: 45,
        odometerKm: 82900,
        noteText:
            'Scheduled 80k km brake pad replacement. Estimated ready: Tomorrow.',
        noteIsWarning: true,
      ),
    ];

    return (request: request, vehicles: vehicles);
  }

  @override
  Future<void> confirmAssignment({
    required String requestId,
    required String vehicleId,
  }) async {
    await Future<void>.delayed(latency);
    // No persistence layer yet — the mock simply succeeds. A real
    // implementation would PATCH the reservation and return the updated
    // trip record.
  }
}
