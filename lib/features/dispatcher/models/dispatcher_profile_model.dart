/// "Dispatcher Profile" — the read-only, directory-synced record shown on
/// the dispatcher's own profile screen.
class DispatcherProfileModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String employeeId;
  final String department;
  final String shift;

  const DispatcherProfileModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.employeeId,
    required this.department,
    required this.shift,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  factory DispatcherProfileModel.fromJson(Map<String, dynamic> json) {
    return DispatcherProfileModel(
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      employeeId: json['employee_id'] as String? ?? '',
      department: json['department'] as String? ?? '',
      shift: json['shift'] as String? ?? '',
    );
  }
}
