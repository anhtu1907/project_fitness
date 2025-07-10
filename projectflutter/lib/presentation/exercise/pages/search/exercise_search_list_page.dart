import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_list_sub_category_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/exercise_list_sub_category_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/widgets/subcategory/exercise_sub_category_row.dart';

class ExerciseSearchListPage extends StatelessWidget {
  final List<ExerciseSubCategoryEntity> total;
  final String subCategoryName;
  final Map<String, int> duration;
  final String level;
  const ExerciseSearchListPage(
      {super.key,
      required this.subCategoryName,
      required this.level,
      required this.duration,
      required this.total});

  @override
  Widget build(BuildContext context) {
    String _formatDuration(int seconds) {
      final duration = Duration(seconds: seconds);
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes.remainder(60));
      final secs = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes:$secs";
    }

    final filteredList = subCategoryName.isEmpty
        ? total
        : total
            .where((e) => e.subCategoryName
                .toLowerCase()
                .contains(subCategoryName.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Search Results',
            style: TextStyle(
                fontSize: AppFontSize.titleAppBar(context),
                fontWeight: FontWeight.w700)),
        subTitle: Text(
          filteredList.length >= 2
              ? '${filteredList.length} workouts'
              : '${filteredList.length} workout',
          style: TextStyle(
              color: AppColors.gray,
              fontSize: AppFontSize.subTitleAppBar(context),
              fontWeight: FontWeight.w500),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: BlocProvider(
        create: (context) => ExerciseListSubCategoryCubit()
          ..listExerciseBySubCategoryName(subCategoryName),
        child: BlocBuilder<ExerciseListSubCategoryCubit,
            ExerciseListSubCategoryState>(
          builder: (context, state) {
            if (state is ListSubCategoryLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoadListSubCategoryFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            if (state is ListSubCategoryLoaded) {
              return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return ExerciseSubcategoryRow(
                          image: item.subCategoryImage,
                          name: item.subCategoryName,
                          duration: _formatDuration(
                              duration[item.subCategoryName] ?? 0),
                          level: level,
                          onPressed: () {
                            AppNavigator.push(
                                context,
                                ExerciseBySubCategoryView(
                                  subCategoryId: item.id,
                                  level: level,
                                  image: item.subCategoryImage,
                                ));
                          });
                    },
                  ));
            }
            return Container();
          },
        ),
      ),
    );
  }
}
