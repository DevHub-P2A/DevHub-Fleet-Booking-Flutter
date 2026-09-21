/// "Admin Profile" — full account/security details, unlike the lighter
/// dispatcher profile.
class AdminProfileModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final String location;
  final String accountStatus;
  final String operationalNote;
  final String securityClearance;
  final String securityNote;
  final DateTime lastLoginAt;
  final String lastLoginLocation;

  const AdminProfileModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.location,
    required this.accountStatus,
    required this.operationalNote,
    required this.securityClearance,
    required this.securityNote,
    required this.lastLoginAt,
    required this.lastLoginLocation,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      role: json['role'] as String? ?? '',
      location: json['location'] as String? ?? '',
      accountStatus: json['account_status'] as String? ?? '',
      operationalNote: json['operational_note'] as String? ?? '',
      securityClearance: json['security_clearance'] as String? ?? '',
      securityNote: json['security_note'] as String? ?? '',
      lastLoginAt:
          DateTime.tryParse(json['last_login_at'] as String? ?? '') ??
          DateTime.now(),
      lastLoginLocation: json['last_login_location'] as String? ?? '',
    );
  }
}
