class UserMealRequest {
  final String user;
  final List<int> meal;
  final DateTime created;
  UserMealRequest({required this.user, required this.meal, required this.created});
}
