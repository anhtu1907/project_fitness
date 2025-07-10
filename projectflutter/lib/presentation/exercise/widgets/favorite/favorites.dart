import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/bloc/favorites_cubit.dart';
import 'package:projectflutter/presentation/exercise/bloc/favorites_state.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_favorite.dart';
import 'package:projectflutter/presentation/exercise/pages/list_favorite.dart';
import 'package:projectflutter/presentation/exercise/widgets/favorite/favorite_card.dart';
import 'package:projectflutter/presentation/exercise/widgets/show/show_dialog_add_favorite.dart';

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
    var media = MediaQuery.of(context).size;
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
                    color: AppColors.black,
                    fontSize: AppFontSize.value16Text(context),
                    fontWeight: FontWeight.bold),
              ),
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoaded && state.entity.isNotEmpty) {
                    return TextButton(
                      onPressed: () {
                        AppNavigator.push(
                          context,
                          ListFavoritePage(totalFavorite: state.entity),
                        );
                      },
                      child: Text(
                        'See All',
                        style: TextStyle(
                            color: AppColors.primaryColor1,
                            fontSize: AppFontSize.value12Text(context),
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
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
                if (favorites.isEmpty) {
                  return Center(
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
                      child: Container(
                        width: media.width * 0.3,
                        height: media.width * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AppColors.gray.withOpacity(0.7),
                          size: AppFontSize.value30Text(context),
                        ),
                      ),
                    ),
                  );
                }
                return SizedBox(
                  height: media.height * 0.2,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favorites.length + 1,
                    itemBuilder: (context, index) {
                      if (index < favorites.length) {
                        final favorite = favorites[index];
                        return FavoriteCard(name: favorite.favoriteName, onTap: ()async{
                          final result = await AppNavigator.pushFuture(
                              context,
                              ExerciseFavoritePage(
                                title: favorite.favoriteName,
                                favoriteId: favorite.id,
                              ));
                          if (result == true) {
                            context.read<FavoritesCubit>().listFavorite();
                          }
                        });
                      } else {
                        return GestureDetector(
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
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 10),
                            width: media.width * 0.5,
                            height: media.width * 0.03,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.black.withOpacity(0.1)),
                            ),
                            child: const Center(
                              child: Icon(Icons.add, size: 30, color: Colors.grey),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
