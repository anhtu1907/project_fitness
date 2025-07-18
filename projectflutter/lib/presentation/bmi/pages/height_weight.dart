import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/components/fields/height_weight_field.dart';
import 'package:projectflutter/common/components/fields/suffix_item.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';
import 'package:projectflutter/domain/bmi/usecase/save_data_usecase.dart';
import 'package:projectflutter/presentation/bmi/pages/bmi_goal.dart';

class HeightWeightPage extends StatefulWidget {
  const HeightWeightPage({super.key});

  @override
  State<HeightWeightPage> createState() => _HeightWeightPageState();
}

class _HeightWeightPageState extends State<HeightWeightPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightCon = TextEditingController();
  final TextEditingController _weightCon = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
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
              AppNavigator.pushReplacement(context, BmiGoalPage());
            }
          },
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: _autovalidateMode,
                            child: Column(
                              children: [
                                SwitchImageType.buildImage(
                                  AppImages.on2,
                                  width: media.width,
                                  fit: BoxFit.fitWidth,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Accurate height and weight lead to better results",
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(flex: 4, child: _heightField()),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        flex: 1,
                                        child: SuffixItem(suffixText: "CM"),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(flex: 4, child: _weightField()),
                                      const SizedBox(width: 10),
                                      const Expanded(
                                        flex: 1,
                                        child: SuffixItem(suffixText: "KG"),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                _continueButton()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _heightField() {
    return HeightWeightField(
      controller: _heightCon,
      hintText: "Height",
      obSecureText: false,
      keyboardType: TextInputType.number,
      prefixIcon: const IconCustom(icon: Icons.straighten),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Height is required';
        }
        final height = double.tryParse(value);
        if (height == null || height < 50 || height > 300) {
          return 'Height must be between 50cm and 300cm';
        }
        return null;
      },
    );
  }

  Widget _weightField() {
    return HeightWeightField(
      controller: _weightCon,
      hintText: "Weight",
      obSecureText: false,
      keyboardType: TextInputType.number,
      prefixIcon: const IconCustom(icon: Icons.monitor_weight),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Weight is required';
        }
        final weight = double.tryParse(value);
        if (weight == null || weight < 10 || weight > 500) {
          return 'Weight must be between 10kg and 500kg';
        }
        return null;
      },
    );
  }

  Widget _continueButton() {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          title: "Continue",
          onPressed: () {
            setState(() {
              _autovalidateMode = AutovalidateMode.always;
            });

            if (_formKey.currentState!.validate()) {
              context.read<ButtonStateCubit>().execute(
                  usecase: SaveDataUsecase(),
                  params: BmiRequest(
                    height: double.parse(_heightCon.text),
                    weight: double.parse(_weightCon.text),
                  ));
            }
          },
        );
      },
    );
  }
}
