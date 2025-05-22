class BmiEntity {
  final int id;
  final double height;
  final double weight;
  final double bmi;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BmiEntity(
      {required this.id,
      required this.height,
      required this.weight,
      required this.bmi,
      required this.createdAt,
      required this.updatedAt});
}
