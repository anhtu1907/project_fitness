import 'package:flutter/material.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/domain/exercise/entity/exercise_sub_category_entity.dart';
import 'package:projectflutter/presentation/exercise/pages/exercise_by_sub_category_view.dart';
import 'package:projectflutter/presentation/exercise/pages/search/exercise_search_list_page.dart';
import 'package:projectflutter/presentation/exercise/widgets/category/exercise_category_list.dart';
import 'package:projectflutter/presentation/exercise/widgets/search/exercise_search_by_duration.dart';
import 'package:projectflutter/presentation/exercise/widgets/search/exercise_search_by_equipment.dart';
import 'package:projectflutter/presentation/exercise/widgets/search/exercise_search_by_goal.dart';
import 'package:projectflutter/presentation/exercise/widgets/search/exercise_search_by_level.dart';

class ExerciseSearchPage extends StatefulWidget {
  final List<ExerciseSubCategoryEntity> subCategoryList;
  final Map<String, int> duration;
  final String level;
  const ExerciseSearchPage(
      {super.key,
      required this.subCategoryList,
      required this.level,
      required this.duration});

  @override
  State<ExerciseSearchPage> createState() => _ExerciseSearchPageState();
}

class _ExerciseSearchPageState extends State<ExerciseSearchPage> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Autocomplete<ExerciseSubCategoryEntity>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<ExerciseSubCategoryEntity>.empty();
            }
            return widget.subCategoryList.where((exercise) => exercise
                .subCategoryName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()));
          },
          displayStringForOption: (ExerciseSubCategoryEntity option) =>
              option.subCategoryName,
          onSelected: (ExerciseSubCategoryEntity selection) {
            AppNavigator.push(
              context,
              ExerciseBySubCategoryView(
                subCategoryId: selection.id,
                level: widget.level,
                image: selection.subCategoryImage,
              ),
            );
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
                hintText: "Search by sub category...",
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
                AppNavigator.push(
                    context,
                    ExerciseSearchListPage(
                        subCategoryName: textEditingController.text,
                        duration: widget.duration,
                        level: widget.level,
                        total: widget.subCategoryList));
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
                        child: Image.asset(
                          option.subCategoryImage,
                          width: media.width * 0.13,
                          height: media.height * 0.065,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(option.subCategoryName),
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
              _sectionTitle('Body Focus'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseCategoryList(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('I\'d like to...'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseSearchByGoal(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('Equipment & Accessories'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseSearchByEquipment(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('Duration'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseSearchByDuration(),
              SizedBox(
                height: media.width * 0.05,
              ),
              _sectionTitle('Level'),
              SizedBox(
                height: media.width * 0.05,
              ),
              const ExerciseSearchByLevel()
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
