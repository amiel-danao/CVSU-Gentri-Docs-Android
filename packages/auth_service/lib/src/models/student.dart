import 'package:equatable/equatable.dart';

class Student extends Equatable {
  const Student({
    required this.userId,
    this.studentID,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.email,
    this.mobile,
    this.picture,
  });

  final String userId;
  final String? studentID;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String? mobile;
  final String? picture;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        userId: json['user_id'] ?? "",
        studentID: json['student_id'] ?? "",
        firstName: json['firstname'] ?? "",
        middleName: json['middlename'] ?? "",
        lastName: json['lastname'] ?? "",
        email: json['email'] ?? "",
        mobile: json['mobile'] ?? "",
        picture: json['picture'] ?? "",
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'user_id': userId,
        'student_id': studentID,
        'firstname': firstName,
        'middlename': middleName,
        'lastname': lastName,
        'email': email,
        'mobile': mobile
      };

  factory Student.empty() => const Student(
        userId: "",
        studentID: "",
        firstName: "",
        middleName: "",
        lastName: "",
        email: "",
        mobile: "",
        picture: "",
      );
  @override
  List<Object?> get props =>
      [userId, firstName, middleName, lastName, email, mobile, picture];
}
