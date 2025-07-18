import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_program_entity.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_sub_category_program_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_card.dart';

class ExerciseSections extends StatelessWidget {
  const ExerciseSections({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ExerciseSubCategoryProgramCubit()..listSubCategoryProgram(),
        ),
        BlocProvider(
          create: (_) => ExercisesCubit()..listExercise(),
        )
      ],
      child: BlocBuilder<ExercisesCubit, ExercisesState>(
        builder: (context, exerciseState) {
          if (exerciseState is ExercisesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (exerciseState is LoadExercisesFailure) {
            return Center(child: Text(exerciseState.errorMessage));
          }
          if (exerciseState is ExercisesLoaded) {
            final exercises = exerciseState.entity;
            final levelBySubCategoryId = _buildLevelMap(exercises);

            return BlocBuilder<ExerciseSubCategoryProgramCubit, ExerciseSubCategoryProgramState>(
              builder: (context, programState) {
                if (programState is SubCategoryProgramLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (programState is LoadSubCategoryProgramFailure) {
                  return Center(child: Text(programState.errorMessage));
                }
                if (programState is SubCategoryProgramLoaded) {
                  final program = programState.entity;
                  return SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _section(context, 'Fresh Morning', program, exercises, levelBySubCategoryId, media),
                        _section(context, 'With Equipment', program, exercises, levelBySubCategoryId, media),
                        _section(context, 'HIIT Workout', program, exercises, levelBySubCategoryId, media),
                      ],
                    ),
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _section(
      BuildContext context,
      String programName,
      List<ExerciseSubCategoryProgramEntity> allItems,
      List<ExercisesEntity> exercises,
      Map<int, String> levelBySubCategoryId,
      Size media,
      ) {
    final items = allItems.where(
          (e) => e.program?.programName.toLowerCase().trim() == programName.toLowerCase().trim(),
    ).toList();

    final durationBySubCategory = _buildDurationMap(exercises);

    final displayList = items.map((e) {
      final id = e.subCategory?.id;
      final level = id != null ? (levelBySubCategoryId[id] ?? 'Unknown') : 'Unknown';
      return (e, level);
    }).toList();

    return Column(
      children: [
        _titleRow(context, programName, durationBySubCategory, displayList),
        SizedBox(height: media.width * 0.05),
        SizedBox(
          height: media.height * 0.25,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final id = item.subCategory!.id;
              final data = _getDurationAndTotal(id, exercises);
              final level = levelBySubCategoryId[id] ?? 'Unknown';
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ExerciseSubCategoryCard(
                  name: item.subCategory!.subCategoryName,
                  subCategoryId: id,
                  level: level,
                  duration: data['duration']!,
                  totalWorkout: data['totalWorkout']!,
                  subName: item.subCategory!.description,
                  image: item.subCategory!.subCategoryImage,
                ),
              );
            },
          ),
        ),
        SizedBox(height: media.width * 0.05),
      ],
    );
  }

  String _resolveLevel(Set<String> modes) {
    const ordered = ['Stretch', 'Beginner', 'Intermediate', 'Advanced'];
    final lowerModes = modes.map((e) => e.toLowerCase()).toSet();

    for (final level in ordered) {
      if (lowerModes.contains(level.toLowerCase())) {
        return level;
      }
    }
    return modes.isNotEmpty
        ? '${modes.first[0].toUpperCase()}${modes.first.substring(1).toLowerCase()}'
        : 'Unknown';
  }

  Map<int, String> _buildLevelMap(List<ExercisesEntity> exercises) {
    Map<int, Set<String>> modeBySubCategoryId = {};

    for (var exercise in exercises) {
      for (var sub in exercise.subCategory) {
        if (exercise.subCategory.length == 1) {
          modeBySubCategoryId.putIfAbsent(sub.id, () => {});
          modeBySubCategoryId[sub.id]!.addAll(
            exercise.modes.map((m) => m.modeName.trim()),
          );
        }
      }
    }

    const ordered = ["Beginner", "Intermediate", "Advanced", "Stretch"];

    return {
      for (var entry in modeBySubCategoryId.entries)
        entry.key: ordered.firstWhere(
              (m) => entry.value.contains(m),
          orElse: () => entry.value.first,
        )
    };
  }

  Map<String, int> _buildDurationMap(List<ExercisesEntity> exercises) {
    final map = <String, int>{};
    for (var ex in exercises) {
      for (var sub in ex.subCategory) {
        map[sub.subCategoryName] = (map[sub.subCategoryName] ?? 0) + ex.duration;
      }
    }
    return map;
  }

  Map<String, int> _getDurationAndTotal(int subCategoryId, List<ExercisesEntity> list) {
    int duration = 0, total = 0;
    for (var ex in list) {
      if (ex.subCategory.any((sub) => sub.id == subCategoryId)) {
        duration += ex.duration;
        total++;
      }
    }
    return {'duration': duration, 'totalWorkout': total};
  }

  Widget _titleRow(
      BuildContext context,
      String title,
      Map<String, int> durationBySubCategory,
      List<(ExerciseSubCategoryProgramEntity, String)> displayList,
      ) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppFontSize.value16Text(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            AppNavigator.push(
              context,
              ExerciseSubCategoryProgramListPage(
                categoryName: title,
                duration: durationBySubCategory,
                total: displayList,
              ),
            );
          },
          child: Text(
            'See All',
            style: TextStyle(
              color: AppColors.primaryColor1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
