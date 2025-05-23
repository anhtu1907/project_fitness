// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:projectflutter/core/config/themes/app_color.dart';
// import 'package:projectflutter/presentation/home/bloc/user_info_display_cubit.dart';
// import 'package:projectflutter/presentation/home/bloc/user_info_display_state.dart';
//
// class DataLineChart extends StatefulWidget {
//   const DataLineChart({super.key});
//
//   @override
//   State<DataLineChart> createState() => _DataLineChartState();
// }
//
// class _DataLineChartState extends State<DataLineChart> {
//   List<Color> gradientColors = [
//     AppColors.contentColorCyan,
//     AppColors.contentColorBlue,
//   ];
//   List<int> allDays = List.generate(30, (index) {
//     final date = DateTime.now().subtract(Duration(days: 29 - index)); // 30 ngày gần nhất tính từ ngày hôm nay
//     return date.day;
//   });
//
//   bool showAvg = false;
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
//       child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
//         builder: (context, state) {
//           if (state is LoadUserInfoFailure) {
//             return Center(
//               child: Text(state.errorMesssage),
//             );
//           }
//           if (state is UserInfoLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (state is UserInfoLoaded) {
//             return Stack(
//               children: <Widget>[
//                 SizedBox(
//                   height: 380,
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       right: 18,
//                       left: 12,
//                       top: 24,
//                       bottom: 12,
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: const [
//                             Text('SubTitle 1',
//                                 style: TextStyle(color: Colors.black)),
//                             Text('SubTitle 2',
//                                 style: TextStyle(color: Colors.black)),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             const SizedBox(width: 55,),
//                             Text('Monthly',
//                                 style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Expanded(
//                           child: LineChart(showAvg ? avgData() : mainData()),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Text('SubTitle 1',
//                                 style: TextStyle(color: Colors.black)),
//                             Text('SubTitle 2',
//                                 style: TextStyle(color: Colors.black)),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('BMI',
//                                     style: TextStyle(color: Colors.black)),
//                                 const SizedBox(height: 8,),
//                                 Row(
//                                   children: [
//                                     Container(
//                                       width: 15,
//                                       height: 15,
//                                       decoration: BoxDecoration(
//                                         color:
//                                         Colors.blue, // màu fill của hình tròn
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 5,
//                                     ),
//                                     Text('BMI',
//                                         style: TextStyle(color: Colors.black)),
//                                   ],
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 60,
//                   height: 34,
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         showAvg = !showAvg;
//                       });
//                     },
//                     child: Text(
//                       'avg',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color:
//                             showAvg ? Colors.black.withAlpha(1) : Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
//
//   Widget bottomTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 16,
//     );
//     int index = value.toInt();
//     if (index < 0 || index >= allDays.length) {
//       return const SizedBox.shrink();
//     }
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 6,
//       child: Text(
//         allDays[index].toString(),
//         style: style,
//       ),
//     );
//   }
//
//   Widget leftTitleWidgets(double value, TitleMeta meta) {
//     const style = TextStyle(
//       fontWeight: FontWeight.bold,
//       fontSize: 15,
//     );
//     String text;
//     switch (value.toInt()) {
//       case 1:
//         text = '10K';
//         break;
//       case 3:
//         text = '30k';
//         break;
//       case 5:
//         text = '50k';
//         break;
//       default:
//         return Container();
//     }
//
//     return Text(text, style: style, textAlign: TextAlign.left);
//   }
//
//   LineChartData mainData() {
//     return LineChartData(
//       gridData: FlGridData(
//         show: true,
//         drawVerticalLine: true,
//         horizontalInterval: 1,
//         verticalInterval: 1,
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: AppColors.mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: AppColors.mainGridLineColor,
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             interval: 1,
//             getTitlesWidget: bottomTitleWidgets,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             interval: 1,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//           ),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           left: BorderSide(color: Color(0xff37434d), width: 1),
//           bottom: BorderSide(color: Color(0xff37434d), width: 1),
//           top: BorderSide.none,
//           right: BorderSide.none,
//         ),
//       ),
//       minX: 0,
//       maxX: allDays.length - 1,
//       minY: 0,
//       maxY: 6,
//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 3),
//             FlSpot(2.6, 2),
//             FlSpot(4.9, 5),
//             FlSpot(6.8, 3.1),
//             FlSpot(8, 4),
//             FlSpot(9.5, 3),
//             FlSpot(11, 4),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: gradientColors,
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors:
//                   gradientColors.map((color) => color.withAlpha(150)).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   LineChartData avgData() {
//     return LineChartData(
//       lineTouchData: LineTouchData(enabled: false),
//       gridData: FlGridData(
//         show: true,
//         drawHorizontalLine: true,
//         verticalInterval: 1,
//         horizontalInterval: 1,
//         getDrawingVerticalLine: (value) {
//           return FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingHorizontalLine: (value) {
//           return FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             reservedSize: 30,
//             getTitlesWidget: bottomTitleWidgets,
//             interval: 1,
//           ),
//         ),
//         leftTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: leftTitleWidgets,
//             reservedSize: 42,
//             interval: 1,
//           ),
//         ),
//         topTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(
//           left: BorderSide(color: Color(0xff37434d), width: 1),
//           bottom: BorderSide(color: Color(0xff37434d), width: 1),
//           top: BorderSide.none,
//           right: BorderSide.none,
//         ),
//       ),
//       minX: 0,
//       maxX: allDays.length - 1,
//       minY: 0,
//       maxY: 5,
//       lineBarsData: [
//         LineChartBarData(
//           isStrokeJoinRound: true,
//           spots: const [
//             FlSpot(0, 3.44),
//             FlSpot(2.6, 3.44),
//             FlSpot(4.9, 3.44),
//             FlSpot(6.8, 3.44),
//             FlSpot(8, 3.44),
//             FlSpot(9.5, 3.44),
//             FlSpot(11, 3.44),
//           ],
//           isCurved: true,
//           gradient: LinearGradient(
//             colors: [
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!
//                   .withAlpha((0.1 * 255).toInt()),
//               ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                   .lerp(0.2)!
//                   .withAlpha((0.1 * 255).toInt()),
//             ],
//           ),
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             gradient: LinearGradient(
//               colors: [
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withAlpha((0.1 * 255).toInt()),
//                 ColorTween(begin: gradientColors[0], end: gradientColors[1])
//                     .lerp(0.2)!
//                     .withAlpha((0.1 * 255).toInt()),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
