import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/check_bmi_state.dart';
import 'package:projectflutter/presentation/bmi/pages/check_bmi_goal.dart';
import 'package:projectflutter/presentation/bmi/pages/height_weight.dart';

class CheckBmiPage extends StatelessWidget {
  const CheckBmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CheckBmiCubit()..checkBmi(),
        child: BlocConsumer<CheckBmiCubit, CheckBmiState>(
          listener: (context, state) {
            if (state is BmiExists) {
              AppNavigator.pushReplacement(context, const CheckBmiGoalPage());
            }
            if (state is BmiNotExists) {
              AppNavigator.pushReplacement(context, HeightWeightPage());
            }
          },
          builder: (context, state) {
            if (state is BmiLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Scaffold(
              appBar: BasicAppBar(hideBack: true),
              body: Center(child: Text('Checking BMI...')),
            );
          },
        ));
  }
}
