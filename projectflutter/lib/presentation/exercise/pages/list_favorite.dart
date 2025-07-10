import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/favorites_entity.dart';
import 'package:projectflutter/presentation/exercise/widgets/favorite/favorite_item_row.dart';

class ListFavoritePage extends StatelessWidget {
  final List<FavoritesEntity> totalFavorite;
  const ListFavoritePage({super.key, required this.totalFavorite});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('List Favorite',style: TextStyle(
            fontSize: AppFontSize.titleAppBar(context),
            fontWeight: FontWeight.w700)),
        subTitle: Text(
          totalFavorite.length < 2 ?
          '${totalFavorite.length} favorite' : '${totalFavorite.length} favorites',
          style: TextStyle(
              color: AppColors.gray,
              fontSize: AppFontSize.subTitleAppBar(context),
              fontWeight: FontWeight.w500),
        ),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
          child: ListView.builder(
        itemCount: totalFavorite.length,
        itemBuilder: (context, index) {
          final favorite = totalFavorite[index];
          return FavoriteItemRow(
              nameFavorite: favorite.favoriteName,
              numberOfFavorite: favorite.id);
        },
      )),
    );
  }
}
