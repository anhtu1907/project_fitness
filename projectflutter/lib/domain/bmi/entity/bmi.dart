class BmiEntity {
  final int id;
  final int height;
  final int weight;
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
