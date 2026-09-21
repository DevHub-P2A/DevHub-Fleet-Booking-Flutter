class DriverTripModel {
  final String tripId;
  final String status;

  final String origin;
  final String originDetails;
  final String departureTime;

  final String destination;
  final String destinationDetails;
  final String estimatedArrival;

  final String vehicleName;
  final String plateNumber;
  final int seats;
  final String fuel;
  final String odometer;

  final int passengerCount;
  final String tripLead;
  final String department;

  final String vehicleStatus;
  final String currentLocation;
  final String speed;

  final String distance;
  final String estimatedTime;

  const DriverTripModel({
    required this.tripId,
    required this.status,
    required this.origin,
    required this.originDetails,
    required this.departureTime,
    required this.destination,
    required this.destinationDetails,
    required this.estimatedArrival,
    required this.vehicleName,
    required this.plateNumber,
    required this.seats,
    required this.fuel,
    required this.odometer,
    required this.passengerCount,
    required this.tripLead,
    required this.department,
    required this.vehicleStatus,
    required this.currentLocation,
    required this.speed,
    required this.distance,
    required this.estimatedTime,
  });
}
