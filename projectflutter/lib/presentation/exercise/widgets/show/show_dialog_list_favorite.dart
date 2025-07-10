import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projectflutter/common/bloc/button/button_state.dart';
import 'package:projectflutter/common/bloc/button/button_state_cubit.dart';
import 'package:projectflutter/common/widget/button/basic_reactive_button.dart';
import 'package:projectflutter/data/exercise/request/exercise_favorite_request.dart';
import 'package:projectflutter/domain/exercise/entity/favorites_entity.dart';
import 'package:projectflutter/domain/exercise/usecase/add_exercise_favorite.dart';
import 'package:projectflutter/domain/exercise/usecase/get_favorites.dart';
import 'package:projectflutter/service_locator.dart';

class ShowDialogListFavorite extends StatefulWidget {
  final int subCategoryId;
  const ShowDialogListFavorite(
      {super.key,required this.subCategoryId});

  @override
  State<ShowDialogListFavorite> createState() => _ShowDialogListFavoriteState();
}

class _ShowDialogListFavoriteState extends State<ShowDialogListFavorite> {
  FavoritesEntity? _selectedFavorite;
  final _formKey = GlobalKey<FormState>();
  List<FavoritesEntity> _favoriteList = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final result = await sl<GetFavoritesUseCase>().call();
    result.fold(
          (failure) {
        debugPrint("Error: $failure");
      },
          (list) {
        setState(() {
          _favoriteList = list;
        });
      },
    );
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
              'Add Exercise to Favorites',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<FavoritesEntity>(
                    value: _selectedFavorite,
                    items: _favoriteList.map((favorite) {
                      return DropdownMenuItem<FavoritesEntity>(
                          value: favorite, child: Text(favorite.favoriteName));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFavorite = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select Favorite',
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
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a favorite';
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
                            print('SubCategoryID: ${widget.subCategoryId} - Favorite List: ${_selectedFavorite!.id}');
                            context.read<ButtonStateCubit>().execute(
                                usecase: AddExerciseFavoriteUseCase(),
                                params: ExerciseFavoriteRequest(
                                    subCategory: widget.subCategoryId,
                                    favorite: _selectedFavorite!.id));
                          }
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
