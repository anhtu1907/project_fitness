import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_new_category.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_equipment_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_program_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/suggest/setting_plan.dart';
import 'package:projectflutter/presentation/exercise/widgets/suggest/exercise_plan_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanExercisePage extends StatefulWidget {
  const PlanExercisePage({super.key});

  @override
  State<PlanExercisePage> createState() => _PlanExercisePageState();
}

class _PlanExercisePageState extends State<PlanExercisePage> {
  List<bool> _selectedDays = List.generate(7, (_) => true);
  bool _isScheduled = false;
  int _selectedDifficultyIndex = 0;
  int _selectedGoalIndex = 0;
  int _selectedDuraitonIndex = 0;
  bool _isLoading = true;
  List<String> _selectedEquipments = [];
  bool matches = true;

  final List<String> _bodyArea = [
    'Full Body',
    'Arm',
    'Butt & Leg',
    'Shoulder',
    'Back',
    'Chest',
    'Core',
  ];
  List<bool> _selectedBodyAreas = List.generate(7, (_) => false);
  final List<String> goals = ['Loss Weight', 'Build Muscle', 'Keep Fit'];
  List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  List<String> durations = [
    '<10 min/day',
    '10-20 min/day',
    '20-30 min/day',
    '30-45 min/day'
  ];
  Map<int,bool> completedDays = {};

  Future<void> _loadFilterSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isScheduled = prefs.getBool('isScheduled') ?? false;
    _selectedDifficultyIndex = prefs.getInt('selectedDifficultyIndex') ?? 0;
    _selectedGoalIndex = prefs.getInt('selectedGoalIndex') ?? 0;
    _selectedDuraitonIndex = prefs.getInt('selectedDurationIndex') ?? 0;
    _selectedEquipments = prefs.getStringList('selectedEquipments') ?? [];
    final savedDays = prefs.getStringList('selectedDays');
    final savedAreas = prefs.getStringList('selectedBodyAreas');
    if (savedAreas != null && savedAreas.length <= _bodyArea.length) {
      _selectedBodyAreas =
          List.generate(_bodyArea.length, (i) => savedAreas.contains(_bodyArea[i]));
    } else {
      _selectedBodyAreas = List.generate(_bodyArea.length, (_) => false);
    }
    if (savedDays != null && savedDays.length == 7) {
      final days = savedDays.map((e) => e == 'true').toList();
      _selectedDays = _isScheduled ? days : List.generate(7, (_) => true);
    } else {
      _selectedDays = List.generate(7, (_) => true);
    }

    for (int i = 1; i <= 28; i++) {
      final done = prefs.getBool('day_${i}_completed') ?? false;
      completedDays[i] = done;
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _checkDurationByIndex(int duration, int index) {
    switch (index) {
      case 1:
        return duration < 600;
      case 2:
        return duration >= 600 && duration <= 1200;
      case 3:
        return duration > 1200 && duration <= 1800;
      case 4:
        return duration > 1800;
      default:
        return true;
    }
  }

  bool _matchesFilter(
      ExercisesEntity exercise, Map<int, String> subCategoryGoalMap) {
    if (_selectedDifficultyIndex != 0 &&
        exercise.modes.first.modeName != difficulties[_selectedDifficultyIndex]) {
      return false;
    }
    if (_selectedGoalIndex != 0 &&
        !exercise.subCategory.any(
            (sub) => subCategoryGoalMap[sub.id] == goals[_selectedGoalIndex])) {
      return false;
    }

    if (_selectedDuraitonIndex != 0 &&
        !_checkDurationByIndex(exercise.duration, _selectedDuraitonIndex)) {
      return false;
    }

    if (_selectedEquipments.isNotEmpty) {
      final equipmentName = exercise.equipment?.equipmentName ?? '';
      if (!_selectedEquipments.any((e) =>
          equipmentName.toLowerCase().contains(e.toLowerCase()))) {
        return false;
      }
    }

    if (_selectedBodyAreas.contains(true)) {
      final selectedIndexes = _selectedBodyAreas
          .asMap()
          .entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();

      final expectedNames = <String>{};

      for (var index in selectedIndexes) {
        final area = _bodyArea[index];
        expectedNames.add(area);
      }
      final matchesBody = exercise.subCategory.every((sub) =>
          sub.category.any((cat) =>
              expectedNames.map((e) => e.toLowerCase()).contains(cat.categoryName.toLowerCase())));

      if (!matchesBody) {
        return false;
      }
    }

    return exercise.duration != null &&
        exercise.kcal != null &&
        exercise.duration > 0 &&
        exercise.kcal > 0;
  }

  @override
  void initState() {
    super.initState();
    _loadFilterSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Plan Exercise',
              style: TextStyle(fontSize: AppFontSize.heading2(context))),
        ),
        action: IconButton(
            onPressed: () {
              AppNavigator.pushFuture(context, const SettingPlanPage())
                  .then((result) {
                if (result == true) {
                  _loadFilterSettings();
                }
              });
            },
            icon: const Icon(Icons.tune)),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ExerciseSubCategoryCubit()..listSubCategory(),
          ),
          BlocProvider(
            create: (context) => ExercisesCubit()..listExercise(),
          ),
          BlocProvider(
            create: (context) =>
                ExerciseEquipmentCubit()..listExerciseEquipment(),
          ),
          BlocProvider(
            create: (context) =>
                ExerciseSubCategoryProgramCubit()..listSubCategoryProgram(),
          ),
        ],
        child: BlocBuilder<ExerciseSubCategoryCubit, ExerciseSubCategoryState>(
          builder: (context, state) {
            if (state is SubCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadSubCategoryFailure) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is SubCategoryLoaded) {
              final listSubCategory = state.entity;
              return BlocBuilder<ExercisesCubit, ExercisesState>(
                builder: (context, exerciseState) {
                  if (exerciseState is ExercisesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (exerciseState is LoadExercisesFailure) {
                    return Center(child: Text(exerciseState.errorMessage));
                  }
                  if (exerciseState is ExercisesLoaded) {
                    final rawList = exerciseState.entity;
                    return BlocBuilder<ExerciseSubCategoryProgramCubit,
                        ExerciseSubCategoryProgramState>(
                      builder: (context, programState) {
                        if (programState is LoadSubCategoryProgramFailure) {
                          return Center(child: Text(programState.errorMessage));
                        }
                        if (programState is SubCategoryProgramLoaded) {
                          final subCategoryGoalMap = {
                            for (var item in programState.entity)
                              if (item.subCategory != null &&
                                  item.program != null)
                                item.subCategory!.id:
                                    item.program!.programName ?? '',
                          };

                          final filteredList = rawList.where((e) => _matchesFilter(e, subCategoryGoalMap)).toList();
                          if (filteredList.isEmpty) return const Center(child: Text('No exercises match your filters.', style: TextStyle(fontSize: 16)));

                          final grouped = <int, List<ExercisesEntity>>{};
                          final durationMap = <int, int>{};
                          final kcalMap = <int, double>{};
                          final levelBySubCategoryId = _buildLevelBySubCategoryId(filteredList);
                          for (final exercise in filteredList) {
                            final validSubs = exercise.subCategory;
                            for (var sub in validSubs) {
                              grouped.putIfAbsent(sub.id, () => []).add(exercise);
                            }
                          }

                          grouped.forEach((id, list) {
                            durationMap[id] = list.fold(0, (sum, e) => sum + e.duration);
                            kcalMap[id] = list.fold(0.0, (sum, e) => sum + e.kcal);
                          });

                          return ExercisePlanItem(
                            groupedSubCategory: grouped,
                            durationBySubCategory: durationMap,
                            isCompleted: completedDays,
                            kcalBySubCategory: kcalMap,
                            levelBySubCategoryId: levelBySubCategoryId,
                            subCategories: listSubCategory.where((sub) => grouped.containsKey(sub.id)).toList(),
                            selectedDays: _selectedDays,
                          );
                          // grouping và return ExercisePlanItem như cũ
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Map<int, String> _buildLevelBySubCategoryId(List<ExercisesEntity> exercises) {
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
          orElse: () => entry.value.isNotEmpty ? entry.value.first : 'Unknown',
        )
    };
  }
}
