import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/usecase/remove_favorite.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_favorite_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_favorite_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/exercise_sub_category_favorite_row.dart';
import 'package:projectflutter/service_locator.dart';

class ExerciseFavoritePage extends StatefulWidget {
  final String title;
  final int favoriteId;
  const ExerciseFavoritePage({super.key, required this.title, required this.favoriteId});

  @override
  State<ExerciseFavoritePage> createState() => _ExerciseFavoritePageState();
}

class _ExerciseFavoritePageState extends State<ExerciseFavoritePage> {
  Map<String, int> duration = {};
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
        title: Text(widget.title),
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
                          onPressed: () =>
                              Navigator.of(context).pop(false),
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
              if(shouldDelete == true){
                sl<RemoveFavoriteUseCase>().call(params: widget.favoriteId);
                Navigator.of(context).pop(true);
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red)),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocProvider(
        create: (context) => ExerciseFavoriteCubit()..listExerciseFavorite(widget.favoriteId),
        child: BlocBuilder<ExerciseFavoriteCubit, ExerciseFavoriteState>(
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
              final exercises = state.entity;
              if(exercises.isEmpty){
                return const Center(
                  child: Text('List Empty'),
                );
              }
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseSubCategoryFavoriteRow(
                        image:
                            exerciseSubCategory[exercises[index].subCategory!.id].toString(),
                        name: exercises[index].subCategory!.subCategoryName,
                        duration: _formatDuration(duration[
                                exercises[index].subCategory!.subCategoryName] ??
                            0),
                        level: exercises[index].subCategory!.mode!.modeName,
                        onPressed: () {
                          AppNavigator.push(
                              context,
                              ExerciseBySubCategoryView(
                                  subCategoryId:
                                      exercises[index].subCategory!.id));
                        });
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
