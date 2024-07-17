class TownOne {
  String type;
  List<double> bbox;
  List<Feature> features;

  TownOne({
    required this.type,
    required this.bbox,
    required this.features
  });

  factory TownOne.fromJson(Map<String, dynamic> json) {
    return TownOne(
      type: json['type'],
      bbox: (json['bbox'] as List<dynamic>).cast<double>(),
      features: (json['features'] as List)
          .map((featureJson) => Feature.fromJson(featureJson))
          .toList(),
    );
  }
}

class Feature {
  String type;
  Geometry geometry;
  Properties properties;
  String id;

  Feature({required this.type, required this.geometry, required this.properties, required this.id});

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      type: json['type'],
      geometry: Geometry.fromJson(json['geometry']),
      properties: Properties.fromJson(json['properties']),
      id: json['id'],
    );
  }
}

class Geometry {
  String type;
  List<List<List<List<double>>>> coordinates;

  Geometry({required this.type, required this.coordinates});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      type: json['type'],
      coordinates: (json['coordinates'] as List)
        .map((level1) => (level1 as List)
          .map((level2) => (level2 as List)
           .map((level3) => (level3 as List)
            .map((coord) => coord as double)
            .toList())
           .toList())
          .toList())
        .toList(),
    );
  }
}

class Properties {
  String emdCd;
  String fullNm;
  String emdKorNm;
  String emdEngNm;

  Properties({
    required this.emdCd,
    required this.fullNm,
    required this.emdKorNm,
    required this.emdEngNm,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      emdCd: json['emd_cd'],
      fullNm: json['full_nm'],
      emdKorNm: json['emd_kor_nm'],
      emdEngNm: json['emd_eng_nm'],
    );
  }
}