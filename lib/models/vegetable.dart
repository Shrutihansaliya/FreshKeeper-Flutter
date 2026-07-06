class Vegetable {
  int? id;
  String name;
  int quantity;
  String imageName;
  String notes;
  String purchaseDate;
  int shelfLifeDays;
  String status;
  int categoryId;
  String type; // 👈 ADD

  Vegetable({
    this.id,
    required this.name,
    required this.quantity,
    required this.imageName,
    required this.notes,
    required this.purchaseDate,
    required this.shelfLifeDays,
    required this.status,
    required this.categoryId,
    required this.type,
  });
}