import 'package:flutter/material.dart';
import 'package:projectflutter/core/config/themes/app_font_size.dart';

class ExplainParameter extends StatelessWidget {
  const ExplainParameter({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height,
      child: SingleChildScrollView(
        child: _rowContent(context),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, String title, String content) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(title,
            style: TextStyle(
                fontSize: AppFontSize.body(context),
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(content,
            style: TextStyle(
                fontSize: AppFontSize.caption(context), color: Colors.black)),
      ),
    ]);
  }

  Widget _rowContent(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      border: TableBorder(
          horizontalInside:
              BorderSide(width: 0.3, color: Colors.grey.shade300)),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _buildTableRow(context, 'Body Fat',
            'The percentage of your total body weight that is made up of fat'),
        _buildTableRow(context, 'SMM',
            'Refers to the amount of muscle connected to bones, allowing movement'),
        _buildTableRow(context, 'TBW',
            'The total amount of fluid in your body, including water in blood, organs, muscles, and fat'),
        _buildTableRow(context, 'ECW/TBW',
            'Represents the proportion of water outside cells (ECW) compared to the total body water (TBW)'),
        _buildTableRow(context, 'BMR',
            'The number of calories your body needs to perform basic functions like breathing, circulation, and cell production while at rest'),
        _buildTableRow(context, 'Fat Mass',
            'The total weight of all the fat in your body, measured in kilograms'),
      ],
    );
  }
}
