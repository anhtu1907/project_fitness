import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_goal_state.dart';
import 'package:projectflutter/presentation/personal/widget/form_edit_weight.dart';
import 'package:projectflutter/presentation/personal/widget/show/show_dialog_current_form.dart';
import 'package:projectflutter/presentation/personal/widget/show/show_dialog_target_form.dart';

class ShowAndEdit extends StatefulWidget {
  const ShowAndEdit({Key? key}) : super(key: key);

  @override
  State<ShowAndEdit> createState() => _ShowAndEditState();
}

class _ShowAndEditState extends State<ShowAndEdit> {
  bool _isPressedCurrent = true;
  bool _isPressedGoal = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Current Weight
          Expanded(
            child: BlocBuilder<HealthCubit, HealthState>(
              builder: (context, state) {
                if (state is HealthLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LoadedHealthFailure) {
                  return Center(child: Text(state.errorMessage));
                }
                if (state is HealthLoaded) {
                  final currentWeight = state.bmi.last.weight;
                  return FormEditWeight(
                    'Current',
                    const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    currentWeight,
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.weightCurrentText(context),
                    ),
                    'kg',
                    TextStyle(
                      color: Colors.black,
                      fontSize: AppFontSize.body(context),
                    ),
                    Icon(
                      Icons.edit,
                      size: AppFontSize.iconLineChart(context),
                      color: Colors.grey,
                    ),
                    CrossAxisAlignment.start,
                    MainAxisAlignment.start,
                        () {
                      showDialog<bool>(
                        context: context,
                        builder: (_) => ShowDialogCurrentForm(
                          weight: currentWeight,
                          title: 'Current Weight',
                        ),
                      ).then((value) {
                        if (!mounted) return;
                        setState(() => _isPressedCurrent = true);
                        if (value == true) {
                          context.read<HealthCubit>().getDataHealth();
                        }
                      });
                      setState(() => _isPressedCurrent = !_isPressedCurrent);
                    },
                    _isPressedCurrent,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<HealthGoalCubit, HealthGoalState>(
              builder: (context, state) {
                if (state is HealthGoalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LoadedHealthGoalFailure) {
                  return Center(child: Text(state.errorMessage));
                }
                if (state is HealthGoalLoaded) {
                  final goalWeight = state.goal.last.targetWeight;
                  return FormEditWeight(
                    'Goal',
                    const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    goalWeight,
                    TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.weightGoalText(context),
                    ),
                    'kg',
                    TextStyle(
                      color: Colors.black,
                      fontSize: AppFontSize.body(context),
                    ),
                    Icon(
                      Icons.edit,
                      size: AppFontSize.iconLineChart(context),
                      color: Colors.grey,
                    ),
                    CrossAxisAlignment.end,
                    MainAxisAlignment.end,
                        () {
                      showDialog<bool>(
                        context: context,
                        builder: (_) => ShowDialogTargetForm(
                          weight: goalWeight,
                          title: 'Target Weight',
                        ),
                      ).then((value) {
                        if (!mounted) return;
                        setState(() => _isPressedGoal = true);
                        if (value == true) {
                          context.read<HealthGoalCubit>().getHealGoal();
                        }
                      });
                      setState(() => _isPressedGoal = !_isPressedGoal);
                    },
                    _isPressedGoal,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
