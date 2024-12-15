class MemberCode {
  int codeItemId;
  String codeItemTitle;
  int codeCategoryId;
  String codeCategoryTitle;
  int codeTypeId;
  String codeTypeTitle;

  MemberCode({
    required this.codeItemId,
    required this.codeItemTitle,
    required this.codeCategoryId,
    required this.codeCategoryTitle,
    required this.codeTypeId,
    required this.codeTypeTitle
  });

  factory MemberCode.fromJson(Map<String, dynamic> json) => MemberCode(
      codeItemId: json["codeItemId"],
      codeItemTitle: json["codeItemTitle"],
      codeCategoryId: json["codeCategoryId"],
      codeCategoryTitle: json["codeCategoryTitle"],
      codeTypeId: json["codeTypeId"],
      codeTypeTitle: json["codeTypeTitle"]
  );
}