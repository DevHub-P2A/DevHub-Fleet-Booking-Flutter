class VehicleModel {
  final String id;
  final String type;
  final String name;
  final String plateNumber;
  final int seats;
  final String transmission;
  final String powertrain;
  final String location;
  final String imageUrl;
  final bool available;

  const VehicleModel({
    required this.id,
    required this.type,
    required this.name,
    required this.plateNumber,
    required this.seats,
    required this.transmission,
    required this.powertrain,
    required this.location,
    required this.imageUrl,
    required this.available,
  });
}
