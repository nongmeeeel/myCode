import 'dart:ffi';

import 'package:mycode/model/local/MemberTown.dart';
import 'package:mycode/model/third_party/Town.dart';

class SignUpRequestDTO {
  final String name;
  final String gender;
  final String birthDate;
  final MemberTown memberTown;

  SignUpRequestDTO({
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.memberTown,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'birthDate': birthDate,
    'memberTown': memberTown.toJson(),  // MemberTown도 toJson 필요
  };
}