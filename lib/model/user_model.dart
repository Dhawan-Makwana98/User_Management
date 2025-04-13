class UserModel {
  final String id;
  final String firstName;
  final String dob;
  final String mobile;

  UserModel({
    required this.id,
    required this.firstName,
    required this.dob,
    required this.mobile,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'firstName': firstName, 'dob': dob, 'mobile': mobile};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      dob: map['dob'] ?? '',
      mobile: map['mobile'] ?? '',
    );
  }
}
