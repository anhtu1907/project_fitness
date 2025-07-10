import 'dart:convert';

import 'package:projectflutter/domain/exercise/entity/exercise_programs_entity.dart';

class ExerciseProgramsModel {
  final int id;
  final String programName;
  const ExerciseProgramsModel({required this.id, required this.programName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'programName': programName};
  }

  factory ExerciseProgramsModel.fromMap(Map<String, dynamic> map) {
    return ExerciseProgramsModel(
        id: map['id'] as int, programName: map['programName'] as String);
  }
  String toJson() => json.encode(toMap());
  factory ExerciseProgramsModel.fromJson(String source) =>
      ExerciseProgramsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseProgramsXModel on ExerciseProgramsModel {
  ExerciseProgramsEntity toEntity() {
    return ExerciseProgramsEntity(id: id, programName: programName);
  }
}
