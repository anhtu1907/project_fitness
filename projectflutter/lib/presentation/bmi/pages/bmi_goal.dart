import 'package:flutter/material.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/components/fields/height_weight_field.dart';
import 'package:projectflutter/common/components/fields/suffix_item.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/domain/bmi/usecase/save_goal_usecase.dart';
import 'package:projectflutter/presentation/bmi/bloc/bmi_goal_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/bmi_goal_state.dart';
import 'package:projectflutter/presentation/bmi/pages/bmi_result_view.dart';

class BmiGoalPage extends StatelessWidget {
  BmiGoalPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) => BmiGoalCubit(),
        )
      ],
      child: BlocListener<ButtonStateCubit, ButtonState>(
        listener: (context, state) {
          if (state is ButtonFailureState) {
            var snackbar = SnackBar(
              content: Text(state.errorMessage),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }
          if (state is ButtonSuccessState) {
            AppNavigator.pushReplacement(context, const BmiResultPage());
          }
        },
        child: GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.on1,
                                width: media.width,
                                fit: BoxFit.fitWidth,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Set your goal by entering your accurate weight for better health insights",
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              _optionTarget(context),
                              const SizedBox(
                                height: 20,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: _weightField(context),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      flex: 1,
                                      child: SuffixItem(suffixText: "KG"),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<BmiGoalCubit, BmiGoalState>(
                                builder: (context, state) {
                                  if (state.error != null &&
                                      state.error!.isNotEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 2),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          state.error!,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 14),
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                              const Spacer(),
                              _continueButton()
                            ],
                          ),
                        )),
                  ),
                ),
              );
            },
          ),
        )),
      ),
    ));
  }

  final List<String> optionList = ['Muscle Gain', 'Weight Loss', 'Maintance'];
  Widget _optionTarget(BuildContext context) {
    return BlocBuilder<BmiGoalCubit, BmiGoalState>(
      builder: (context, state) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: optionList.length,
            itemBuilder: (context, index) {
              final isSelected = state.selectedOption == optionList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<BmiGoalCubit>()
                          .selectedOption(optionList[index]);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? AppColors.primaryColor1 : Colors.grey,
                      foregroundColor: isSelected ? Colors.white : Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryColor1
                              : Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      optionList[index],
                    )),
              );
            },
          ),
        );
      },
    );
  }

  Widget _weightField(BuildContext context) {
    return BlocBuilder<BmiGoalCubit, BmiGoalState>(
      builder: (context, state) {
        return HeightWeightField(
          controller: _weightCon,
          hintText: "Weight",
          obSecureText: false,
          keyboardType: TextInputType.number,
          prefixIcon: const IconCustom(icon: Icons.monitor_weight),
          onChanged: (value) {
            context.read<BmiGoalCubit>().updateWeight(value!);
            return;
          },
        );
      },
    );
  }

  Widget _continueButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
            title: "Continue",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await context.read<BmiGoalCubit>().saveGoal();
                final error = context.read<BmiGoalCubit>().state.error;
                if (error == null) {
                  if (context.mounted) {
                    context.read<ButtonStateCubit>().execute(
                        usecase: SaveGoalUsecase(),
                        params: double.parse(_weightCon.text));
                  }
                }
              }
            });
      },
    );
  }
}
