class Town {
  final String id;
  final String title;
  final double x;
  final double y;


  Town({
    required this.id,
    required this.title,
    required this.x,
    required this.y
  });

  factory Town.fromJson(Map<String, dynamic> json) => Town(
    id: json["id"],
    title: json["title"],
    x: double.parse(json["point"]["x"]),
    y: double.parse(json["point"]["y"])
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'x': x,
      'y': y,
    };
  }
}