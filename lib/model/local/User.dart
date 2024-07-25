import 'dart:ffi';

import 'package:mycode/model/local/UserTown.dart';

class User {
  final String id;
  final String? kakaoId;
  final String? kakaoNickname;
  final String name;
  final String gender;
  final String birthDate;
  final String? email;
  final String? phoneNumber;
  final UserTown userTown;
  final String? role;

  User({
    required this.id,
    required this.kakaoId,
    required this.kakaoNickname,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.userTown,
    required this.role
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      kakaoId: json['kakaoId'],
      kakaoNickname: json['kakaoNickname'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userTown: UserTown.fromJson(json['userTown']),
      role: json['role'],
    );
  }
}