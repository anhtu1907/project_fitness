import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/domain/bmi/usecase/update_data_usecase.dart';

class ShowDialogCurrentForm extends StatefulWidget {
  final double weight;
  final String title;
  const ShowDialogCurrentForm(
      {super.key, required this.weight, required this.title});

  @override
  State<ShowDialogCurrentForm> createState() => _ShowDialogCurrentFormState();
}

class _ShowDialogCurrentFormState extends State<ShowDialogCurrentForm> {
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _weightController.text = widget.weight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) async {
              if (state is ButtonFailureState) {
                final snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
              if (state is ButtonSuccessState) {
                const snackbar = SnackBar(
                  content: Text("Update Successfully!"),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                Navigator.of(context).pop(true);
              }
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Weight',
                        prefixIcon: const Padding(
                          padding: const EdgeInsets.all(12),
                          child: FaIcon(
                            FontAwesomeIcons.weightScale,
                            size: 30,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.grey, // Màu viền khi chưa focus
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.black, // Màu viền khi focus
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Weight is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Builder(builder: (context) {
                        return BasicReactiveButton(
                          title: "Done",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ButtonStateCubit>().execute(
                                  usecase: UpdateDataUsecase(),
                                  params: double.parse(_weightController.text));
                            }
                          },
                        );
                      }),
                    )
                  ],
                ),
              ),
            )));
  }
}
