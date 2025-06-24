import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/domain/bmi/usecase/update_data_usecase.dart';
import 'package:projectflutter/domain/exercise/usecase/add_favorite.dart';

class ShowDialogAddFavorite extends StatefulWidget {
  const ShowDialogAddFavorite({super.key});

  @override
  State<ShowDialogAddFavorite> createState() => _ShowDialogAddFavoriteState();
}

class _ShowDialogAddFavoriteState extends State<ShowDialogAddFavorite> {
  final _favoriteNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                  content: Text("Add Successfully!"),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                Navigator.of(context).pop(true);
              }
            },
            child: AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'New Favorite',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _favoriteNameController,
                      decoration: InputDecoration(
                        labelText: 'Favorite Name',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12),
                          child: FaIcon(
                            FontAwesomeIcons.star,
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
                          return 'Name is required';
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
                                  usecase: AddFavoriteUsecase(),
                                  params: _favoriteNameController.text);
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
