class ReservationModel {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String plateNumber;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String status;
  final double totalPrice;

  const ReservationModel({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.plateNumber,
    required this.pickupDate,
    required this.returnDate,
    required this.status,
    required this.totalPrice,
  });
}
