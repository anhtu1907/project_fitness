import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/components/fields/height_weight_field.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:projectflutter/data/bmi/request/bmi_request.dart';
import 'package:projectflutter/domain/bmi/usecase/save_data_usecase.dart';
import 'package:projectflutter/presentation/bmi/pages/bmi_view.dart';

class HeightWeightPage extends StatelessWidget {
  HeightWeightPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightCon = TextEditingController();
  final TextEditingController _weightCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const BasicAppBar(
        hideBack: true,
      ),
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
              AppNavigator.pushReplacement(context, const BmiPage());
            }
          },
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            AppImages.on2,
                            width: media.width * 0.8,
                            fit: BoxFit.fitWidth,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Accurate height and weight lead to better results",
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
                          _heightField(),
                          const SizedBox(
                            height: 20,
                          ),
                          _weightField(),
                          const Spacer(),
                          _continueButton()
                        ],
                      )),
                ),
              )),
        ),
      ),
    );
  }

  Widget _heightField() {
    return HeightWeightField(
      controller: _heightCon,
      hintText: "Height",
      suffixText: 'CM',
      obSecureText: false,
      keyboardType: TextInputType.number,
      prefixIcon: const IconCustom(icon: Icons.straighten),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Height is required';
        }
        if (double.parse(value) < 50 || double.parse(value) > 300) {
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
      suffixText: "KG",
      obSecureText: false,
      keyboardType: TextInputType.number,
      prefixIcon: const IconCustom(icon: Icons.monitor_weight),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Weight is required';
        }
        if (double.parse(value) < 10 || double.parse(value) > 500) {
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
              if (_formKey.currentState!.validate()) {
                context.read<ButtonStateCubit>().execute(
                    usecase: SaveDataUsecase(),
                    params: BmiRequest(
                        height: double.parse(_heightCon.text),
                        weight: double.parse(_weightCon.text)));
              }
            });
      },
    );
  }
}
