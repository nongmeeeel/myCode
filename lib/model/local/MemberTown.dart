class MemberTown {
  final String id;
  final String title;
  final double x;
  final double y;


  MemberTown({
    required this.id,
    required this.title,
    required this.x,
    required this.y
  });

  factory MemberTown.fromJson(Map<String, dynamic> json) => MemberTown(
      id: json["id"],
      title: json["title"],
      x: json["x"],
      y: json["y"]
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'x': x,
    'y': y
  };
}