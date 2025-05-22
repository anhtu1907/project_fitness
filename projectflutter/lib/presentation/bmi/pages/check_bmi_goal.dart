import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_goal_state.dart';
import 'package:projectflutter/presentation/bmi/pages/bmi_goal.dart';
import 'package:projectflutter/presentation/home/pages/tabs.dart';

class CheckBmiGoalPage extends StatelessWidget {
  const CheckBmiGoalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CheckBmiGoalCubit()..checkBmiGoal(),
        child: BlocConsumer<CheckBmiGoalCubit, CheckBmiGoalState>(
          listener: (context, state) {
            if (state is BmiGoalExists) {
              AppNavigator.pushReplacement(context, const TabsPage());
            }
            if (state is BmiGoalNotExists) {
              AppNavigator.pushReplacement(context, BmiGoalPage());
            }
          },
          builder: (context, state) {
            if (state is BmiGoalLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BmiGoalError) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return const Scaffold(
              appBar: BasicAppBar(hideBack: true),
              body: Center(child: Text('Checking BMI  Goal...')),
            );
          },
        ));
  }
}
