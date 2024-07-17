class Town {
  final String emdCd;
  final String fullNm;
  final String emdKorNm;
  final String emdEngNm;
  // final List<List<double>> coordinates;

  Town({
    required this.emdCd,
    required this.fullNm,
    required this.emdKorNm,
    required this.emdEngNm,
    // required this.coordinates,
  });

  factory Town.fromJson(Map<String, dynamic> json) {
    return Town(
      emdCd: json['properties']['emd_cd'],
      fullNm: json['properties']['full_nm'],
      emdKorNm: json['properties']['emd_kor_nm'],
      emdEngNm: json['properties']['emd_eng_nm']
    );
  }
}