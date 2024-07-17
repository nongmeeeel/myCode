class UserTown {
  final String townCode;
  final String fullNm;
  final String nm;
  final String engNm;
  final double lat;
  final double lng;
  final double zoomLevel;
  // final List<List<double>> coordinates;

  UserTown({
    required this.townCode,
    required this.fullNm,
    required this.nm,
    required this.engNm,
    required this.lat,
    required this.lng,
    required this.zoomLevel,
    // required this.coordinates,
  });

  factory UserTown.fromJson(Map<String, dynamic> json) {
    return UserTown(
        townCode: json['townCode'],
        fullNm: json['fullNm'],
        nm: json['nm'],
        engNm: json['engNm'],
        lat: json['lat'],
        lng: json['lng'],
        zoomLevel: json['zoomLevel']
    );
  }
}