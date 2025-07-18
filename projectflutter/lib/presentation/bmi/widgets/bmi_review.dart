import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectflutter/common/helper/image/switch_image_type.dart';
import 'package:projectflutter/common/helper/navigation/app_navigator.dart';
import 'package:projectflutter/common/widget/button/round_button.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_cubit.dart';
import 'package:projectflutter/presentation/bmi/bloc/health_state.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
import 'package:projectflutter/presentation/home/pages/bmi_details.dart';

class BmiReview extends StatelessWidget {
  const BmiReview({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => HealthCubit()..getDataHealth(),
      child: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          if (state is HealthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadedHealthFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          if (state is HealthLoaded) {
            final health = state.bmi;
            return Container(
              height: media.width * 0.4,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: AppColors.primaryG),
                  border: Border.all(color: AppColors.gray.withOpacity(0.15)),
                  borderRadius: BorderRadius.circular(30)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SwitchImageType.buildImage(
                    AppImages.bgDots,
                    height: media.width * 0.4,
                    fit: BoxFit.fitHeight,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 25),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMI (Body Mass Index)',
                              style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: AppFontSize.caption(context),
                                  fontWeight: FontWeight.w700),
                            ),
                            if (health.last.bmi < 18.4)
                              Text(
                                'You have a underweight',
                                style: TextStyle(
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            if (health.last.bmi >= 18.5 &&
                                health.last.bmi < 24.9)
                              Text(
                                'You have a normal weight',
                                style: TextStyle(
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            if (health.last.bmi >= 25 && health.last.bmi < 29.9)
                              Text(
                                'You have a overweight',
                                style: TextStyle(
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            if (health.last.bmi >= 30.0 &&
                                health.last.bmi < 34.9)
                              Text(
                                'You have a obesity',
                                style: TextStyle(
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            if (health.last.bmi >= 35.0 &&
                                health.last.bmi < 40.0)
                              Text(
                                'You have a obesity II',
                                style: TextStyle(
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: AppFontSize.content(context),
                                    fontWeight: FontWeight.w700),
                              ),
                            SizedBox(
                              height: media.width * 0.03,
                            ),
                            SizedBox(
                                width: 120,
                                height: 35,
                                child: RoundButton(
                                  title: "View More",
                                  onPressed: () {
                                    AppNavigator.push(
                                        context, const BmiDetailsPage());
                                  },
                                  fontSize: AppFontSize.content(context),
                                  fontWeight: FontWeight.w400,
                                  type: RoundButtonType.bgSGradient,
                                ))
                          ],
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              var size = constraints.maxWidth * 0.6;
                              return _showBmi(health.last.bmi, size);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _showBmi(double bmi, double size) {
    Color containerColor;
    containerColor = AppColors.underweight;
    if (bmi >= 18.5 && bmi < 24.9) {
      containerColor = AppColors.normalweight;
    }
    if (bmi >= 25.0 && bmi < 29.9) {
      containerColor = AppColors.overweight;
    }
    if (bmi >= 30.0 && bmi < 34.9) {
      containerColor = AppColors.obesity;
    }
    if (bmi >= 35 && bmi < 40.0) {
      containerColor = AppColors.obesitysecond;
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: containerColor,
          boxShadow: [
            BoxShadow(
                color: containerColor.withOpacity(0.7),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, 0.0))
          ]),
      child: Center(
        child: Text(
          bmi.toStringAsFixed(1),
          style: TextStyle(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
