import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/bottomnavigator/app_bottom_navigator.dart';
// import 'package:projectflutter/core/config/assets/app_image.dart';
// import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/presentation/exercise/pages/exercises_view.dart';
import 'package:projectflutter/presentation/home/bloc/tab_display_cubit.dart';
import 'package:projectflutter/presentation/home/pages/home_view.dart';
import 'package:projectflutter/presentation/meal/pages/meals_view.dart';
import 'package:projectflutter/presentation/personal/pages/personal_view.dart';
import 'package:projectflutter/presentation/profile/pages/profile_view.dart';

class TabsPage extends StatelessWidget {
  const TabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Widget> _screens = [
      HomPage(),
      MealsPage(),
      PersonalPage(),
      ExercisesPage(),
      ProfilePage(),
    ];

    return BlocProvider(
      create: (context) => TabDisplayCubit(),
      child: BlocBuilder<TabDisplayCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            body: _screens[currentIndex],
            // floatingActionButton: Container(
            //   width: 70,
            //   height: 70,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     gradient: LinearGradient(
            //         colors: AppColors.primaryG,
            //         begin: Alignment.topRight,
            //         end: Alignment.bottomLeft),
            //     boxShadow: [
            //       BoxShadow(
            //           color: AppColors.primaryColor1,
            //           blurRadius: 20,
            //           spreadRadius: 5,
            //           offset: const Offset(0, 0.0)),
            //     ],
            //   ),
            //   child: FloatingActionButton(
            //     onPressed: () => context.read<TabDisplayCubit>().changeTab(2),
            //     backgroundColor: AppColors.primaryColor1,
            //     elevation: 0,
            //     shape: const CircleBorder(),
            //     child: Image.asset(
            //       AppImages.run,
            //       width: 50,
            //     ),
            //   ),
            // ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerDocked,
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
