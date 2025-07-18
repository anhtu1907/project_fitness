import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/meal/entity/meals.dart';
import 'package:projectflutter/presentation/meal/pages/meal_info_details.dart';
import 'package:projectflutter/presentation/meal/pages/search/meal_search_list.dart';
import 'package:projectflutter/presentation/meal/widgets/search/meal_search_by_calories.dart';
import 'package:projectflutter/presentation/meal/widgets/search/meal_search_by_goal.dart';
import 'package:projectflutter/presentation/meal/widgets/search/meal_type_list_search.dart';

class MealSearchPage extends StatefulWidget {
  final List<MealsEntity> mealList;
  const MealSearchPage({super.key, required this.mealList});

  @override
  State<MealSearchPage> createState() => _MealSearchPageState();
}

class _MealSearchPageState extends State<MealSearchPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Autocomplete<MealsEntity>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<MealsEntity>.empty();
            }
            return widget.mealList.where((meal) => meal.mealName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (MealsEntity option) => option.mealName,
          onSelected: (MealsEntity selection) {
            AppNavigator.push(context, MealInfoDetails(mealId: selection.id));
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            textEditingController.addListener(() {
              setState(() {});
            });
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: "Search by meal...",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide.none,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide.none,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: textEditingController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          textEditingController.clear();
                          focusNode.unfocus();
                        },
                      )
                    : null,
              ),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                // Navigator.pop(context);
                AppNavigator.push(
                  context,
                  MealSearchList(mealName: value),
                );
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.white,
                elevation: 4,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);
                    return ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SwitchImageType.buildImage(
                            option.mealImage,
                            width: media.width * 0.13,
                            height: media.height * 0.065,
                            fit: BoxFit.cover,
                          )),
                      title: Text(option.mealName),
                      onTap: () => onSelected(option),
                    );
                  },
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Meal Types'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const MealTypeListSearch(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('I\'d like to...'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const MealSearchByGoal(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('Calories Goal'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const MealSearchByCalories()
            ],
          ),
        ),
      )),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.black,
            fontSize: AppFontSize.titleAppBar(context),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
