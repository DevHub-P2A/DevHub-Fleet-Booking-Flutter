/// Lifecycle of a department's vehicle request, as shown in the
/// Dispatcher Dashboard and the Reservation Requests queue.
enum RequestStatus {
  pending,
  approved,
  rejected;

  String get label => switch (this) {
    RequestStatus.pending => 'Pending',
    RequestStatus.approved => 'Approved',
    RequestStatus.rejected => 'Rejected',
  };

  static RequestStatus fromApi(String? value) => switch (value?.toLowerCase()) {
    'approved' => RequestStatus.approved,
    'rejected' => RequestStatus.rejected,
    _ => RequestStatus.pending,
  };
}

class ReservationRequestModel {
  final String id;
  final String requesterName;
  final String department;
  final String origin;
  final String destination;
  final DateTime scheduledAt;
  final int passengerCount;
  final String vehicleType;
  final String purpose;
  final RequestStatus status;

  /// When the requester submitted it — drives the "2h ago" caption.
  final DateTime submittedAt;

  const ReservationRequestModel({
    required this.id,
    required this.requesterName,
    required this.department,
    required this.origin,
    required this.destination,
    required this.scheduledAt,
    required this.passengerCount,
    required this.vehicleType,
    required this.purpose,
    required this.status,
    required this.submittedAt,
  });

  String get route => '$origin → $destination';

  ReservationRequestModel copyWith({RequestStatus? status}) {
    return ReservationRequestModel(
      id: id,
      requesterName: requesterName,
      department: department,
      origin: origin,
      destination: destination,
      scheduledAt: scheduledAt,
      passengerCount: passengerCount,
      vehicleType: vehicleType,
      purpose: purpose,
      status: status ?? this.status,
      submittedAt: submittedAt,
    );
  }

  /// Ready for the real API — the mock repository doesn't call this yet, but
  /// wiring an HTTP client later needs no model changes.
  factory ReservationRequestModel.fromJson(Map<String, dynamic> json) {
    return ReservationRequestModel(
      id: json['id'] as String,
      requesterName: json['requester_name'] as String? ?? '',
      department: json['department'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      destination: json['destination'] as String? ?? '',
      scheduledAt:
          DateTime.tryParse(json['scheduled_at'] as String? ?? '') ??
          DateTime.now(),
      passengerCount: json['passenger_count'] as int? ?? 0,
      vehicleType: json['vehicle_type'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      status: RequestStatus.fromApi(json['status'] as String?),
      submittedAt:
          DateTime.tryParse(json['submitted_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'requester_name': requesterName,
    'department': department,
    'origin': origin,
    'destination': destination,
    'scheduled_at': scheduledAt.toIso8601String(),
    'passenger_count': passengerCount,
    'vehicle_type': vehicleType,
    'purpose': purpose,
    'status': status.name,
    'submitted_at': submittedAt.toIso8601String(),
  };
}
