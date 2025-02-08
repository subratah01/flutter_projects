class UserDataModel {
  final String email;
  final String firstName;
  final String lastName;
  final String mobile;
  final String password;
  final String photo;

  UserDataModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.password,
    this.photo = "",
  });

}
