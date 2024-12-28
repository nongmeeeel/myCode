import '../Member.dart';
import 'MemberCode.dart';

class FetchMemberResponseDTO {
  final Member member;
  final List<MemberCode> memberCodeList;
  final List<MemberCode> memberCodeFilterList;

  FetchMemberResponseDTO({
    required this.member,
    required this.memberCodeList,
    required this.memberCodeFilterList,
  });

  factory FetchMemberResponseDTO.fromJson(Map<String, dynamic> json) {
    return FetchMemberResponseDTO(
      member: Member.fromJson(json['memberResponseDTO']),
      memberCodeList: (json['memberCodeResponseDTOList'] as List)
          .map((item) => MemberCode.fromJson(item))
          .toList(),
      memberCodeFilterList: (json['memberCodeFilterResponseDTOList'] as List)
          .map((item) => MemberCode.fromJson(item))
          .toList(),
    );
  }
}
