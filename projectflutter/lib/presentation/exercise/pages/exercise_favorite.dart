import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercises_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/remove_favorite.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_favorite_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_favorite_state.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercises_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_favorite_row.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseFavoritePage extends StatefulWidget {
  final String title;
  final int favoriteId;
  const ExerciseFavoritePage(
      {super.key, required this.title, required this.favoriteId});

  @override
  State<ExerciseFavoritePage> createState() => _ExerciseFavoritePageState();
}

class _ExerciseFavoritePageState extends State<ExerciseFavoritePage> {
  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(widget.title,style: TextStyle(
            fontSize: AppFontSize.titleAppBar(context),
            fontWeight: FontWeight.w700)),
        action: IconButton(
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'Are you sure you want to delete this favorite?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ]);
                },
              );
              if (shouldDelete == true) {
                sl<RemoveFavoriteUseCase>().call(params: widget.favoriteId);
                Navigator.of(context).pop(true);
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ExerciseFavoriteCubit()
                ..listExerciseFavorite(widget.favoriteId),
            ),
            BlocProvider(
              create: (context) => ExercisesCubit()..listExercise(),
            )
          ],
          child: BlocBuilder<ExercisesCubit, ExercisesState>(
            builder: (context, state) {
              if (state is ExercisesLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoadExercisesFailure) {
                return Center(
                  child: Text(state.errorMessage),
                );
              }
              if (state is ExercisesLoaded) {
                final exerciseList = state.entity;
                return BlocBuilder<ExerciseFavoriteCubit,
                    ExerciseFavoriteState>(
                  builder: (context, state) {
                    if (state is ExerciseFavoriteLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is LoadExerciseFavoriteFailure) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    }
                    if (state is ExerciseFavoriteLoaded) {
                      final exerciseFavorites = state.entity;
                      if (exerciseFavorites.isEmpty) {
                        return const Center(
                          child: Text('List Favorite Empty'),
                        );
                      }
                      final favoriteSubCategoryIds = exerciseFavorites
                          .map((e) => e.subCategory!.id)
                          .toSet();

                      final filteredExerciseList = exerciseList.where((exercise){
                        return exercise.subCategory.any((sub) => favoriteSubCategoryIds.contains(sub.id));
                      }).toList();
                      Map<String, List<ExercisesEntity>> groupedSubCategoryMode = {};
                      for (var exercise in filteredExerciseList) {
                        final modeName = exercise.mode?.modeName ?? "Unknown";
                        for (var sub in exercise.subCategory) {
                          if (favoriteSubCategoryIds.contains(sub.id)) {
                            final subCategoryName = sub.subCategoryName;
                            final key = "$subCategoryName-$modeName";
                            groupedSubCategoryMode
                                .putIfAbsent(key, () => [])
                                .add(exercise);
                          }
                        }
                      }

                      Map<String, int> durationBySubCategory = {};
                      groupedSubCategoryMode.forEach((subCatName, exercises) {
                        durationBySubCategory[subCatName] =
                            exercises.fold(0, (sum, item) => sum += item.duration);
                      });


                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),

                        child: ListView(
                          children: groupedSubCategoryMode.entries.map((entry) {
                            final key = entry.key;
                            final exercises = entry.value;

                            final parts = key.split('-');
                            final subCategoryName = parts[0];
                            final modeName = parts.length > 1 ? parts[1] : "";

                            final subCategory = exercises.first.subCategory.first;
                            final subCategoryId = subCategory.id;
                            final subCategoryImage = subCategory.subCategoryImage;

                            return ExerciseSubCategoryFavoriteRow(
                              image: subCategoryImage,
                              name: subCategoryName,
                              duration: _formatDuration(durationBySubCategory[key] ?? 0),
                              level: modeName,
                              onPressed: () {
                                AppNavigator.push(
                                    context,
                                    ExerciseBySubCategoryView(
                                      subCategoryId: subCategoryId,
                                      level: modeName,
                                      image: subCategoryImage,
                                    ));
                              },
                            );
                          }).toList(),
                        )
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return Container();
            },
          )),
    );
  }
}
