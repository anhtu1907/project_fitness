class BmiGoalEntity {
  final int id;
  final double targetWeight;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BmiGoalEntity(
      {required this.id,
      required this.targetWeight,
      required this.createdAt,
      required this.updatedAt});
}
