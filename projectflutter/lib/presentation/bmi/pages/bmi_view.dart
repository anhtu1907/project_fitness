import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_button.dart';
import 'package:projectflutter/presentation/bmi/bloc/show_bmi_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/show_bmi_state.dart';
import 'package:projectflutter/presentation/home/pages/tabs.dart';

class BmiPage extends StatelessWidget {
  const BmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(
        hideBack: true,
      ),
      body: BlocProvider(
        create: (context) => ShowBmiCubit()..displayBmi(),
        child: BlocBuilder<ShowBmiCubit, ShowBmiState>(
          builder: (context, state) {
            if (state is BmiLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is LoadedBmiFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            if (state is BmiLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bmiCalculator(state.bmi),
                    const Spacer(),
                    _continueButton(context)
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _bmiCalculator(double bmi) {
    final List<Color> bmiColor = [
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red
    ];

    var colorIndex = 0;
    String bmiStatus = 'Underweight';
    if (bmi >= 18.5 && bmi < 24.9) {
      colorIndex = 1;
      bmiStatus = "Normal weight";
    }
    if (bmi >= 25.0 && bmi < 29.9) {
      colorIndex = 2;
      bmiStatus = "Overweight";
    }
    if (bmi >= 30.0 && bmi < 34.9) {
      colorIndex = 3;
      bmiStatus = "Obesity";
    }
    if (bmi >= 35 && bmi < 40.0) {
      colorIndex = 4;
      bmiStatus = "Obesity II";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'BMI: ${bmi.toStringAsFixed(1)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    bmiColor.length,
                    (index) {
                      return Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          color: bmiColor[index],
                        ),
                      );
                    },
                  )
                ],
              ),
              Positioned(
                  left: 60 * colorIndex + 25,
                  top: -18,
                  child: const Icon(
                    Icons.arrow_drop_up,
                    color: Colors.black,
                    size: 50,
                  ))
            ],
          ),
          const SizedBox(height: 20),
          Text(
            bmiStatus,
            style: TextStyle(
                color: bmiColor[colorIndex],
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicButton(
        title: 'Continue',
        onPressed: () {
          AppNavigator.pushReplacement(context, const TabsPage());
        });
  }
}
