import 'dart:convert';

import 'package:projectflutter/data/exercise/model/exercise_programs_model.dart';
import 'package:projectflutter/data/exercise/model/exercise_sub_category_model.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';

class ExerciseSubCategoryProgramModel {
  final int id;
  final ExerciseSubCategoryModel? subCategory;
  final ExerciseProgramsModel? program;
  const ExerciseSubCategoryProgramModel(
      {required this.id, required this.subCategory, required this.program});

  Map<String, dynamic> toMap() {
    return {'id': id, 'subCategory': subCategory, 'program': program};
  }

  factory ExerciseSubCategoryProgramModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSubCategoryProgramModel(
        id: map['id'] as int,
        subCategory: map['subCategory'] != null
            ? ExerciseSubCategoryModel.fromMap(
                map['subCategory'] as Map<String, dynamic>)
            : null,
        program: map['program'] != null
            ? ExerciseProgramsModel.fromMap(map['program'])
            : null);
  }

  String toJson() => json.encode(toMap());
  factory ExerciseSubCategoryProgramModel.fromJson(String source) =>
      ExerciseSubCategoryProgramModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ExerciseSubCategoryProgramXModel on ExerciseSubCategoryProgramModel {
  ExerciseSubCategoryProgramEntity toEntity() {
    return ExerciseSubCategoryProgramEntity(
        id: id, subCategory: subCategory, program: program);
  }
}
