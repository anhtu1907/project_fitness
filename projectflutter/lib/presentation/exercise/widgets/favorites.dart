import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/bloc/favorites_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/favorites_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_favorite.dart';
import 'package:projectflutter/presentation/exercise/widgets/show_dialog_add_favorite.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late FavoritesCubit favoritesCubit;
  @override
  void initState() {
    super.initState();
    favoritesCubit = FavoritesCubit()..listFavorite();
  }

  @override
  void dispose() {
    favoritesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: favoritesCubit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorite',
                  style: TextStyle(
                      color: AppColors.primaryColor1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey)),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const ShowDialogAddFavorite();
                        },
                      ).then((value) {
                        if (value == true) {
                          favoritesCubit.listFavorite();
                        }
                      });
                    },
                    child: Center(
                        child: Icon(
                      Icons.add,
                      color: AppColors.gray.withOpacity(0.7),
                      size: 20,
                    )),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LoadFavoritesFailure) {
                  return Center(
                    child: Text(state.errorMessage),
                  );
                }
                if (state is FavoritesLoaded) {
                  final favorites = state.entity;
                  if(favorites.isEmpty){
                    return const Center(
                      child: Text('List Favorite Empty'),
                    );
                  }
                  return SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = favorites[index];
                        return GestureDetector(
                            onTap: () async {
                              final result = await AppNavigator.pushFuture(
                                  context,
                                  ExerciseFavoritePage(
                                    title: favorite.favoriteName,
                                    favoriteId: favorite.id,
                                  ));
                              if (result == true) {
                                context.read<FavoritesCubit>().listFavorite();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.only(right: 10),
                              width: 200,
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: Center(
                                child: Text(favorite.favoriteName),
                              ),
                            ));
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ));
  }
}
