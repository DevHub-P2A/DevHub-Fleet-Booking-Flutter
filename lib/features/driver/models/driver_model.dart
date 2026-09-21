class DriverModel {
  final String id;
  final String name;
  final String employeeId;
  final String role;
  final String department;
  final String location;
  final String shift;
  final int completedTrips;
  final String safetyRating;
  final String currentVehicle;

  final String licenseNumber;
  final String licenseType;
  final String endorsements;
  final String licenseExpiry;
  final String licenseIssueDate;
  final String issuingAuthority;

  final String assignedVehicle;
  final String vehiclePlate;
  final String vehicleYear;
  final String vehicleCapacity;
  final String keyStatus;

  final String backgroundCheckStatus;
  final String backgroundCheckDetails;

  const DriverModel({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.role,
    required this.department,
    required this.location,
    required this.shift,
    required this.completedTrips,
    required this.safetyRating,
    required this.currentVehicle,
    required this.licenseNumber,
    required this.licenseType,
    required this.endorsements,
    required this.licenseExpiry,
    required this.licenseIssueDate,
    required this.issuingAuthority,
    required this.assignedVehicle,
    required this.vehiclePlate,
    required this.vehicleYear,
    required this.vehicleCapacity,
    required this.keyStatus,
    required this.backgroundCheckStatus,
    required this.backgroundCheckDetails,
  });
}
