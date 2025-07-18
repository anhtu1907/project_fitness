import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/bottomnavigator/app_bottom_navigator.dart';
import 'package:projectflutter/presentation/exercise/pages/exercises_view.dart';
import 'package:projectflutter/presentation/exercise/pages/suggest/plan_exercise.dart';
import 'package:projectflutter/presentation/home/bloc/tab_display_cubit.dart';
import 'package:projectflutter/presentation/home/pages/home_view.dart';
import 'package:projectflutter/presentation/meal/pages/meals_view.dart';
import 'package:projectflutter/presentation/profile/pages/profile_view.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> _screens = [
      HomPage(),
      MealsPage(),
      PlanExercisePage(),
      ExercisesPage(),
      ProfilePage(),
    ];

    return BlocProvider(
      create: (context) => TabDisplayCubit(),
      child: BlocBuilder<TabDisplayCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: _screens[currentIndex],
            bottomNavigationBar: AppBottomNavigator(
              currentIndex: currentIndex,
              onTap: (index) =>
                  context.read<TabDisplayCubit>().changeTab(index),
            ),
          );
        },
      ),
    );
  }
}
