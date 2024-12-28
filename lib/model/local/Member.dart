import 'package:mycode/model/local/MemberTown.dart';

class Member {
  final int id;
  final String loginType;
  final String? kakaoNickname;
  final String name;
  final String gender;
  final String birthDate;
  final String email;
  final String? phoneNumber;
  final MemberTown memberTown;
  final String? role;

  Member(
      {required this.id,
      required this.loginType,
      required this.kakaoNickname,
      required this.name,
      required this.gender,
      required this.birthDate,
      required this.email,
      required this.phoneNumber,
      required this.memberTown,
      required this.role});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      loginType: json['loginType'],
      kakaoNickname: json['kakaoNickname'],
      name: json['name'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      memberTown: MemberTown.fromJson(json['memberTown']),
      role: json['role'],
    );
  }
}
