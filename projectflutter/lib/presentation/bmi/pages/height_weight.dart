import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/components/fields/height_weight_field.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/core/icon/icon_custom.dart';
import 'package:projectflutter/data/bmi/model/bmi_request.dart';
import 'package:projectflutter/domain/bmi/usecase/save_data_usecase.dart';
import 'package:projectflutter/presentation/bmi/pages/bmi.dart';

class HeightWeightPage extends StatelessWidget {
  HeightWeightPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _heightCon = TextEditingController();
  final TextEditingController _weightCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _heightField(),
                      const SizedBox(
                        height: 20,
                      ),
                      _weightField(),
                      const SizedBox(
                        height: 20,
                      ),
                      _continueButton()
                    ],
                  )),
            )),
          ),
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
