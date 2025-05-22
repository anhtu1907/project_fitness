import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/bottomsheet/app_bottom_sheet.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/domain/auth/entity/user.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/home/widgets/explain_parameter.dart';

class BmiDetailsPage extends StatelessWidget {
  const BmiDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BasicAppBar(
          hideBack: true,
          title: Text(
            "BMI Details",
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
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _bodyFat(),
                        const SizedBox(
                          height: 15,
                        ),
                        _bmiUserDetails(state.user, context),
                      ],
                    ),
                  ),
                ));
              }
              return Container();
            },
          ),
        ));
  }

  Widget _bodyFat() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(1.5),
        },
        border: TableBorder(
            horizontalInside:
                BorderSide(width: 0.3, color: Colors.grey.shade300)),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          _buildTableRow('Type', 'Male (%)', 'Female (%)', isHeader: true),
          _buildTableRow('Essential fat', '2 - 5%', '10 - 13%'),
          _buildTableRow('Athletes', '6 – 13%', '14 – 20%'),
          _buildTableRow('Fitness', '14 – 17%', '21 – 24%'),
          _buildTableRow('Normal', '18 – 24%', '25 – 31%'),
          _buildTableRow('Overweight', '25 – 30%', '32 – 38%'),
          _buildTableRow('Obese', '31 – 35%', '39 – 43%'),
          _buildTableRow('Obese II', '≥36%', '≥44%'),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String label, String male, String female,
      {bool isHeader = false}) {
    final style = TextStyle(
      color: AppColors.black,
      fontSize: isHeader ? 16 : 14,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );

    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label, style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(male, style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(female, style: style),
      ),
    ]);
  }

  TableRow _buildTableRowDetails(String label, dynamic value,
      {String unit = '', bool isHeader = false}) {
    final style = TextStyle(
      color: AppColors.black,
      fontSize: isHeader ? 16 : 14,
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
    );

    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(label, style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text('$value $unit', style: style),
      )
    ]);
  }

  Widget _bmiUserDetails(UserEntity user, BuildContext context) {
    final today = DateTime.now();
    int age = today.year - user.dob.year;
    double? bodyfat;
    double? smm; // Khối lượng cơ xương
    double? tbw; // Tổng lượng nước trong cơ thể
    double? bmr; // Tỷ lệ trao đổi chất
    double? fatmass; // Khối lượng mỡ cơ thể
    Color? color;
    if (user.gender == 1) {
      bodyfat = (1.20 * user.bmi!.bmi) + (0.23 * age) - 16.2;
      smm = user.bmi!.bmi * 0.407;
      tbw = user.bmi!.weight * 0.6;
      bmr = 88.362 +
          (13.397 * user.bmi!.weight) +
          (4.799 * user.bmi!.height) -
          (5.677 * age);
      fatmass = user.bmi!.weight * (bodyfat / 100);
    } else if (user.gender == 2) {
      bodyfat = (1.20 * user.bmi!.bmi) + (0.23 * age) - 5.4;
      smm = user.bmi!.bmi * 0.407;
      tbw = user.bmi!.weight * 0.55;
      bmr = 447.593 +
          (9.247 * user.bmi!.weight) +
          (3.098 * user.bmi!.height) -
          (4.330 * age);
      fatmass = user.bmi!.weight * (bodyfat / 100);
    }
    var bmiName = '';
    if (user.bmi!.bmi < 18.4) {
      color = AppColors.underweight;
      bmiName = 'Underweight';
    }

    if (user.bmi!.bmi >= 18.5 && user.bmi!.bmi < 24.9) {
      color = AppColors.normalweight;
      bmiName = 'Normalweight';
    }
    if (user.bmi!.bmi >= 25 && user.bmi!.bmi < 29.9) {
      color = AppColors.overweight;
      bmiName = 'Overweight';
    }

    if (user.bmi!.bmi >= 30.0 && user.bmi!.bmi < 34.9) {
      color = AppColors.obesity;
      bmiName = 'Obesity';
    }

    if (user.bmi!.bmi >= 35.0 && user.bmi!.bmi < 40.0) {
      color = AppColors.obesitysecond;
      bmiName = 'Obesity II';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                            color: color!,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: const Offset(1, 0))
                      ]),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    bmiName,
                    style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    AppBottomSheet.display(context, const ExplainParameter());
                  },
                  icon: const Icon(
                    Icons.help_outline_outlined,
                    size: 20,
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 2)
              ],
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
              },
              border: TableBorder(
                  horizontalInside:
                      BorderSide(width: 0.3, color: Colors.grey.shade300)),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _buildTableRowDetails('Type', 'Value', isHeader: true),
                _buildTableRowDetails(
                    'Body Fat ', '${bodyfat!.toStringAsFixed(1)}%'),
                _buildTableRowDetails('SMM', '~${smm!.toStringAsFixed(1)}kg'),
                _buildTableRowDetails('TBW', '~${tbw!.toStringAsFixed(0)}L'),
                _buildTableRowDetails('ECW/TBW', '~0.36'),
                _buildTableRowDetails('BMR', '${bmr!.toStringAsFixed(0)}kcal'),
                _buildTableRowDetails(
                    'Fat Mass', '~${fatmass!.toStringAsFixed(1)}kg'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
