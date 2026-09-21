class TripModel {
  final String id;
  final String reservationId;
  final String vehicleId;
  final String vehicleName;
  final String plateNumber;

  final int seats;
  final String powertrain;
  final String transmission;

  final String pickupLocation;
  final String destination;

  final DateTime pickupDate;
  final DateTime returnDate;

  final String currentLocation;
  final double speed;

  final int odometer;

  const TripModel({
    required this.id,
    required this.reservationId,
    required this.vehicleId,
    required this.vehicleName,
    required this.plateNumber,
    required this.seats,
    required this.powertrain,
    required this.transmission,
    required this.pickupLocation,
    required this.destination,
    required this.pickupDate,
    required this.returnDate,
    required this.currentLocation,
    required this.speed,
    required this.odometer,
  });
}
