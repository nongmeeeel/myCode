import '../Code.dart';
import '../Member.dart';
import 'MemberCode.dart';

class FetchMemberResponseDTO {
  final Member member;
  final List<MemberCode> memberCodeList;

  FetchMemberResponseDTO({
    required this.member,
    required this.memberCodeList,
  });

  factory FetchMemberResponseDTO.fromJson(Map<String, dynamic> json) {
    return FetchMemberResponseDTO(
      member: Member.fromJson(json['memberResponseDTO']),
      memberCodeList: (json['memberCodeResponseDTOList'] as List)
          .map((item) => MemberCode.fromJson(item))
          .toList(),
    );
  }
}