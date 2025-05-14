import 'dart:math';

import 'package:flutter/material.dart';
import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:projectflutter/core/config/assets/app_image.dart';
import 'package:projectflutter/core/config/themes/app_color.dart';

class CalendarCustom extends StatefulWidget {
  const CalendarCustom({super.key, this.onDateSelected});
  final void Function(DateTime selectedDate)? onDateSelected;
  @override
  State<CalendarCustom> createState() => _CalendarCustomState();
}

class _CalendarCustomState extends State<CalendarCustom> {
  final CalendarAgendaController _calendarAgendaControllerAppBar =
      CalendarAgendaController();

  late DateTime selectedDateAppBBar;
  late DateTime selectedDateNotAppBBar;

  Random random = new Random();

  @override
  void initState() {
    super.initState();
    selectedDateAppBBar = DateTime.now();
    selectedDateNotAppBBar = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        CalendarAgenda(
          controller: _calendarAgendaControllerAppBar,
          appbar: false,
          selectedDayPosition: SelectedDayPosition.right,
          leading: IconButton(
            icon: Image.asset(
              AppImages.arrowLeft,
              width: 15,
              height: 15,
            ),
            onPressed: () {},
          ),
          training: IconButton(
            icon: Image.asset(
              AppImages.arrowRight,
              width: 15,
              height: 15,
            ),
            onPressed: () {},
          ),
          weekDay: WeekDay.short,
          dayNameFontSize: 12,
          dayNumberFontSize: 16,
          titleSpaceBetween: 15,
          backgroundColor: Colors.white,
          dayBGColor: Colors.grey.withOpacity(0.15),
          fullCalendarScroll: FullCalendarScroll.horizontal,
          fullCalendarDay: WeekDay.short,
          selectedDateColor: Colors.white,
          dateColor: Colors.black,
          locale: 'en',
          initialDate: DateTime.now(),
          calendarEventColor: AppColors.primaryColor2,
          firstDate: DateTime.now().subtract(const Duration(days: 140)),
          lastDate: DateTime.now().add(const Duration(days: 60)),
          events: List.generate(
              100,
              (index) => DateTime.now()
                  .subtract(Duration(days: index * random.nextInt(5)))),
          onDateSelected: (date) {
            setState(() {
              selectedDateAppBBar = date;
            });
            if (widget.onDateSelected != null) {
              widget.onDateSelected!(date);
            }
          },
          selectedDayLogo: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColors.primaryG,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),
      ],
    ));
  }
}
