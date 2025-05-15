import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/data/exercise_sub_category_image.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_schedule_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/delete_schedule.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/home/bloc/exercise_schedule_cubit.dart';

class ExerciseScheduleRow extends StatelessWidget {
  final ExerciseScheduleEntity entity;
  const ExerciseScheduleRow({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    String _formattedDate =
        DateFormat("dd/MM/yyy").format(entity.scheduleTime!);
    String _formattedTime = DateFormat("HH:mm").format(entity.scheduleTime!);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Row(
        children: [
          ClipRRect(
            // borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              exerciseSubCategory[entity.subCategory!.id].toString(),
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.subCategory!.subCategoryName,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    'Date: ',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    _formattedDate,
                    style: TextStyle(color: AppColors.gray, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    'Time: ',
                    style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    _formattedTime,
                    style: TextStyle(color: AppColors.gray, fontSize: 14),
                  ),
                ],
              ),
            ],
          )),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'details') {
                final result = await AppNavigator.pushFuture(
                    context,
                    ExerciseBySubCategoryView(
                        subCategoryId: entity.subCategory!.id));
                if (result == true) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      context.read<ExerciseScheduleCubit>().displaySchedule();
                    }
                  });
                }
              } else if (value == 'delete') {
                final deleteUseCase = DeleteScheduleUseCase();
                await deleteUseCase.call(params: entity.id);

                if (context.mounted) {
                  context.read<ExerciseScheduleCubit>().displaySchedule();
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'details',
                child: Text('View Details'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: Image.asset(
              AppImages.moreV,
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
          )
        ],
      ),
    );
  }
}
