import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_favorite.dart';

class FavoriteItemRow extends StatelessWidget {
  final int numberOfFavorite;
  final String nameFavorite;

  const FavoriteItemRow({
    super.key,
    required this.nameFavorite,
    required this.numberOfFavorite,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            AppNavigator.push(
              context,
              ExerciseFavoritePage(
                title: nameFavorite,
                favoriteId: numberOfFavorite,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor3.withOpacity(0.3),
                  AppColors.primaryColor4.withOpacity(0.3)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Circle number badge
                Container(
                  width: media.width * 0.15,
                  height: media.height * 0.06,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor3,
                        AppColors.primaryColor4
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$numberOfFavorite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.value16Text(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: media.width * 0.05),
                // Title
                Expanded(
                  child: Text(
                    nameFavorite,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppFontSize.value18Text(context),
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Star icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    CupertinoIcons.star_fill,
                    color: Colors.deepOrange,
                    size: AppFontSize.value20Text(context),
                  ),
                ),
                 SizedBox(width: media.width * 0.02),
                // Chevron
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: AppFontSize.value24Text(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
