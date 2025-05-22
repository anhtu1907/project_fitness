class BmiGoalState {
  final String? selectedOption;
  final String weight;
  final String? error;

  BmiGoalState({this.selectedOption, this.weight = '', this.error});
  bool get isValid {
    final doubleWeight = double.parse(weight);
    return selectedOption != null && doubleWeight >= 10 && doubleWeight <= 500;
  }

  BmiGoalState copyWith(
      {String? selectedOption, String? weight, String? error}) {
    return BmiGoalState(
        selectedOption: selectedOption ?? this.selectedOption,
        weight: weight ?? this.weight,
        error: error);
  }
}
