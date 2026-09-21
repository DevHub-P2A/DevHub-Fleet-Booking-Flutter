class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String department;
  final String campusAddress;
  final String emergencyContact;
  final String facultyId;
  final String profileImageUrl;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.department,
    required this.campusAddress,
    required this.emergencyContact,
    required this.facultyId,
    required this.profileImageUrl,
  });
}
