import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/api/shared_preference_service.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell.dart';
import 'package:projectflutter/presentation/profile/widgets/account_setting.dart';
import 'package:projectflutter/presentation/profile/widgets/avatar_item.dart';
import 'package:projectflutter/presentation/profile/widgets/logout_button.dart';
import 'package:projectflutter/presentation/profile/widgets/other_setting.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => UserInfoDisplayCubit()..displayUserInfo()),
          BlocProvider(create: (_) => HealthCubit()..getDataHealth()),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// User Info Section
                BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
                  builder: (context, state) {
                    if (state is UserInfoLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is UserInfoLoaded) {
                      final user = state.user;
                      return Row(
                        children: [
                          AvatarItem(user: user),
                          SizedBox(width: media.width * 0.03),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${user.firstName} ${user.lastName}',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: AppFontSize.value16Text(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }

                    return const Center(
                        child: Text("Failed to load user info"));
                  },
                ),

                SizedBox(height: media.height * 0.02),
                const LogoutButton(),
                SizedBox(height: media.height * 0.025),

                /// Health Info Section
                BlocBuilder<HealthCubit, HealthState>(
                  builder: (context, state) {
                    if (state is HealthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is LoadedHealthFailure) {
                      return Center(child: Text(state.errorMessage));
                    }

                    if (state is HealthLoaded) {
                      final healthList = state.bmi;
                      final userId = SharedPreferenceService.userId;
                      if (userId == null || healthList.isEmpty) {
                        return const Text("No health data available");
                      }

                      final currentUserHealth = healthList
                          .where((e) => e.user?.id == userId)
                          .toList();

                      if (currentUserHealth.isEmpty) {
                        return const Text("No health data for this user");
                      }

                      final latestHealth = currentUserHealth.last;

                      return Row(
                        children: [
                          Expanded(
                            child: TitleSubtitleCell(
                              value: latestHealth.height.toStringAsFixed(0),
                              subtitle: "Height",
                              unit: "cm",
                            ),
                          ),
                          SizedBox(width: media.width * 0.04),
                          Expanded(
                            child: TitleSubtitleCell(
                              value: latestHealth.weight.toStringAsFixed(0),
                              subtitle: "Weight",
                              unit: "kg",
                            ),
                          ),
                          SizedBox(width: media.width * 0.04),
                          Expanded(
                            child: TitleSubtitleCell(
                              value: latestHealth.bmi.toStringAsFixed(1),
                              subtitle: "BMI",
                              unit: "kg/m²",
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox(); // Fallback
                  },
                ),

                SizedBox(height: media.height * 0.025),
                const AccountSetting(),
                SizedBox(height: media.height * 0.025),
                const OtherSetting(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccoutSetting {
  final String imageIcon;
  final String title;
  final VoidCallback onPressed;

  AccoutSetting(
      {required this.imageIcon, required this.title, required this.onPressed});
}
