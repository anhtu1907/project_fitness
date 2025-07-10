import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) =>
                UserInfoDisplayCubit()
                  ..displayUserInfo()),
            BlocProvider(create: (context) =>
            HealthCubit()
              ..getDataHealth()),
          ],
          child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
            builder: (context, state) {
              if (state is UserInfoLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is UserInfoLoaded) {
                final user = state.user;
                final formatedDate =
                DateFormat('dd/MM/yyyy').format(user.createdAt!);
                return BlocBuilder<HealthCubit, HealthState>(
                  builder: (context, state) {
                    if (state is LoadedHealthFailure) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    }
                    if (state is HealthLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is HealthLoaded) {
                      final health = state.bmi;
                      final userId = SharedPreferenceService.userId;
                      final currentUserHealth =
                      health.where((e) => e.user!.id == userId).toList();
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
                                    AvatarItem(user: user,),
                                    SizedBox(
                                      width: media.width * 0.03,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${user.firstname} ${user.lastname}',
                                          style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: AppFontSize.value16Text(context),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Joined on: $formatedDate',
                                          style: TextStyle(
                                              color: AppColors.gray,
                                              fontSize: AppFontSize.value14Text(context),
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: media.height * 0.02,
                                ),
                                const LogoutButton(),
                                SizedBox(
                                  height: media.height * 0.025,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TitleSubtitleCell(
                                        value: currentUserHealth.first.height
                                            .toStringAsFixed(0),
                                        subtitle: "Height",
                                        unit: "cm",
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.04,
                                    ),
                                    Expanded(
                                      child: TitleSubtitleCell(
                                        value: currentUserHealth.last.weight
                                            .toStringAsFixed(0),
                                        subtitle: "Weight",
                                        unit: "kg",
                                      ),
                                    ),
                                    SizedBox(
                                      width: media.width * 0.04,
                                    ),
                                    Expanded(
                                      child: TitleSubtitleCell(
                                        value: currentUserHealth.last.bmi
                                            .toStringAsFixed(1),
                                        subtitle: "BMI",
                                        unit: "kg/m²",
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: media.height * 0.025,
                                ),
                                const AccountSetting(),
                                SizedBox(
                                  height: media.height * 0.025,
                                ),
                                const OtherSetting(),

                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                );
              }
              return Container();
            },
          )),
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
