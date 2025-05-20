import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell_double.dart';
import 'package:projectflutter/presentation/home/widgets/title_subtitle_cell_int.dart';

class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BasicAppBar(
          hideBack: false,
          title: Text(
            "Personal Data",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        body: BlocProvider(
            create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
            child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
              builder: (context, state) {
                if (state is UserInfoLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is UserInfoLoaded) {
                  final today = DateTime.now();
                  final age = today.year - state.user.dob.year;
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _avatarProfile(state.user),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  child: TitleSubtitleCellDouble(
                                    value: 13.5,
                                    subtitle: "Distance",
                                    unit: "km",
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                const Expanded(
                                  child: TitleSubtitleCellDouble(
                                    value: 330.0,
                                    subtitle: "Burned",
                                    unit: "kcal",
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TitleSubtitleCellInt(
                                    value: age,
                                    subtitle: "Age",
                                    unit: "yrs",
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            _bodyProfile(state.user),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            )));
  }

  Widget _avatarProfile(UserEntity user) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.asset(
          user.image.isEmpty
              ? (user.gender == 1 ? AppImages.male : AppImages.female)
              : user.image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ));
  }

  Widget _bodyProfile(UserEntity user) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(user.dob);
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('First Name'),
          subtitle: Text(user.firstname),
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text('Last Name'),
          subtitle: Text(user.lastname),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Date of Birth'),
          subtitle: Text(formattedDate),
        ),
        ListTile(
          leading: user.gender == 1
              ? const Icon(Icons.male)
              : const Icon(Icons.female),
          title: const Text('Gender'),
          subtitle: Text(user.gender == 1 ? 'Male' : 'Female'),
        ),
        ListTile(
          leading: const Icon(Icons.phone),
          title: const Text('Phone'),
          subtitle: Text(user.phone),
        ),
      ],
    );
  }
}
