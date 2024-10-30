import 'dart:ffi';

import 'package:mycode/model/local/UserTown.dart';

class Member {
  final String id;
  final String loginType;
  final String? kakaoNickname;
  final String name;
  final String gender;
  final String birthDate;
  final String email;
  final String? phoneNumber;
  final UserTown memberTown;
  final String? role;

  Member({
    required this.id,
    required this.loginType,
    required this.kakaoNickname,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    required this.memberTown,
    required this.role
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'].toString(),
      loginType: json['loginType'],
      kakaoNickname: json['kakaoNickname'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      memberTown: UserTown.fromJson(json['memberTown']),
      role: json['role'],
    );
  }
}