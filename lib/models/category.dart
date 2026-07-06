class Category {
  int? id;
  String name;
  String createdAt;
  String type; // 👈 ADD

  Category({
    this.id,
    required this.name,
    required this.createdAt,
    required this.type,
  });
}