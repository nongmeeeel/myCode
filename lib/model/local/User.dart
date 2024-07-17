import 'dart:ffi';

import 'package:mycode/model/local/UserTown.dart';

class User {
  final String id;
  final String snsCode;
  final String name;
  final String gender;
  final String birthDate;
  final String email;
  final String phoneNumber;
  final UserTown userTown;

  User({
    required this.id,
    required this.snsCode,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.userTown,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      snsCode: json['snsCode'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userTown: UserTown.fromJson(json['userTown']),
    );
  }
}