import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/personal/setting_row.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';
import 'package:projectflutter/presentation/auth/pages/signin.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell_double.dart';
import 'package:projectflutter/presentation/profile/pages/achievement.dart';
import 'package:projectflutter/presentation/profile/pages/contact_us.dart';
import 'package:projectflutter/presentation/profile/pages/personal_data.dart';
import 'package:projectflutter/presentation/profile/pages/privacy_policy.dart';
import 'package:projectflutter/presentation/profile/pages/setting.dart';
import 'package:projectflutter/presentation/profile/pages/workout_progress.dart';
import 'package:projectflutter/presentation/profile/pages/history.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserInfoLoaded) {
              final formatedDate =
                  DateFormat('dd/MM/yyyy').format(state.user.createdAt);
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _avatarProfile(state.user),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${state.user.firstname} ${state.user.lastname}',
                                  style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Joined on: $formatedDate',
                                  style: TextStyle(
                                      color: AppColors.gray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _logoutButton(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TitleSubtitleCellDouble(
                                value: state.user.bmi!.height,
                                subtitle: "Height",
                                unit: "cm",
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TitleSubtitleCellDouble(
                                value: state.user.bmi!.weight,
                                subtitle: "Weight",
                                unit: "kg",
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: TitleSubtitleCellDouble(
                                value: state.user.bmi!.bmi,
                                subtitle: "BMI",
                                unit: "kg/m²",
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        accountSetting(context),
                        const SizedBox(
                          height: 20,
                        ),
                        otherSetting(context),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ));
  }

  Widget _avatarProfile(UserEntity user) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          user.image.isEmpty
              ? (user.gender == 1 ? AppImages.male : AppImages.female)
              : user.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ));
  }

  Widget accountSetting(BuildContext context) {
    List<AccoutSetting> accountData = [
      AccoutSetting(
          imageIcon: AppImages.pPersonsal,
          title: "Personal Data",
          onPressed: () {
            AppNavigator.push(context, const PersonalDataPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pAchi,
          title: "Achievement",
          onPressed: () {
            AppNavigator.push(context, const AchievementPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pActivity,
          title: "Activity History",
          onPressed: () {
            AppNavigator.push(context, const HistoryPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pWorkout,
          title: "Workout Progress",
          onPressed: () {
            AppNavigator.push(context, const WorkoutProgressPage());
          }),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accountData.length,
            itemBuilder: (context, index) {
              return SettingRow(
                  imageIcon: accountData[index].imageIcon,
                  title: accountData[index].title,
                  onPressed: accountData[index].onPressed);
            },
          )
        ],
      ),
    );
  }

  Widget otherSetting(BuildContext context) {
    List<AccoutSetting> otherData = [
      AccoutSetting(
          imageIcon: AppImages.pContact,
          title: "Contact Us",
          onPressed: () {
            AppNavigator.push(context, const ContactUsPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pPrivacy,
          title: "Privacy Policy",
          onPressed: () {
            AppNavigator.push(context, const PrivacyPolicyPage());
          }),
      AccoutSetting(
          imageIcon: AppImages.pSetting,
          title: "Setting",
          onPressed: () {
            AppNavigator.push(context, const SettingPage());
          }),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Other',
            style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: otherData.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return SettingRow(
                  imageIcon: otherData[index].imageIcon,
                  title: otherData[index].title,
                  onPressed: otherData[index].onPressed);
            },
          )
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return Builder(
      builder: (context) {
        return ElevatedButton.icon(
          onPressed: () {
            context.read<UserInfoDisplayCubit>().logout();
            AppNavigator.pushAndRemoveUntil(context, SigninPage());
          },
          label: const Text('Logout'),
          icon: const Icon(Icons.logout),
        );
      },
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
