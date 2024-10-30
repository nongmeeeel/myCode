class Bounds {
  double southWestLat;
  double southWestLng;
  double northEastLat;
  double northEastLng;

  Bounds({
    required this.southWestLat,
    required this.southWestLng,
    required this.northEastLat,
    required this.northEastLng,
  });

  Map<String, dynamic> toJson() {
    return {
      'southWestLat': southWestLat,
      'southWestLng': southWestLng,
      'northEastLat': northEastLat,
      'northEastLng': northEastLng,
    };
  }
}