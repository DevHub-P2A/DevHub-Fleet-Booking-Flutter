/// Availability of a vehicle against one specific reservation request —
/// not a general fleet status. The same vehicle could be `available` for
/// one request and `conflict` for another.
enum VehicleAssignmentStatus {
  available,
  conflict,
  maintenance;

  String get label => switch (this) {
    VehicleAssignmentStatus.available => 'Available',
    VehicleAssignmentStatus.conflict => 'Conflict',
    VehicleAssignmentStatus.maintenance => 'Maintenance',
  };
}

/// One card in the "Available Fleet Vehicles" grid on the Vehicle
/// Assignment screen.
class FleetVehicleModel {
  final String id;
  final String name;
  final String type;
  final String bayLocation;
  final VehicleAssignmentStatus status;

  final int seatCapacity;
  final bool meetsSeatRequirement;

  /// e.g. "Diesel Level", "Battery & Fuel", "Battery"
  final String energyLabel;
  final int energyPercent;
  final int? rangeKm;

  final int odometerKm;
  final bool inspectionComplete;

  /// Shown as a coloured note under the card — conflict/maintenance detail,
  /// or a positive maintenance confirmation.
  final String? noteText;
  final bool noteIsWarning;

  const FleetVehicleModel({
    required this.id,
    required this.name,
    required this.type,
    required this.bayLocation,
    required this.status,
    required this.seatCapacity,
    required this.meetsSeatRequirement,
    required this.energyLabel,
    required this.energyPercent,
    this.rangeKm,
    required this.odometerKm,
    this.inspectionComplete = false,
    this.noteText,
    this.noteIsWarning = false,
  });

  bool get isSelectable => status == VehicleAssignmentStatus.available;

  factory FleetVehicleModel.fromJson(Map<String, dynamic> json) {
    return FleetVehicleModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      bayLocation: json['bay_location'] as String? ?? '',
      status: VehicleAssignmentStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => VehicleAssignmentStatus.available,
      ),
      seatCapacity: json['seat_capacity'] as int? ?? 0,
      meetsSeatRequirement: json['meets_seat_requirement'] as bool? ?? true,
      energyLabel: json['energy_label'] as String? ?? 'Fuel Level',
      energyPercent: json['energy_percent'] as int? ?? 0,
      rangeKm: json['range_km'] as int?,
      odometerKm: json['odometer_km'] as int? ?? 0,
      inspectionComplete: json['inspection_complete'] as bool? ?? false,
      noteText: json['note_text'] as String?,
      noteIsWarning: json['note_is_warning'] as bool? ?? false,
    );
  }
}
