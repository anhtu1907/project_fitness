import 'package:flutter/material.dart';

class ExplainParameter extends StatelessWidget {
  const ExplainParameter({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height,
      child: SingleChildScrollView(
        child: _rowContent(),
      ),
    );
  }

  TableRow _buildTableRow(String title, String content) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(content,
            style: const TextStyle(fontSize: 14, color: Colors.black)),
      ),
    ]);
  }

  Widget _rowContent() {
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
        _buildTableRow('Body Fat',
            'The percentage of your total body weight that is made up of fat'),
        _buildTableRow('SMM',
            'Refers to the amount of muscle connected to bones, allowing movement'),
        _buildTableRow('TBW',
            'The total amount of fluid in your body, including water in blood, organs, muscles, and fat'),
        _buildTableRow('ECW/TBW',
            'Represents the proportion of water outside cells (ECW) compared to the total body water (TBW)'),
        _buildTableRow('BMR',
            'The number of calories your body needs to perform basic functions like breathing, circulation, and cell production while at rest'),
        _buildTableRow('Fat Mass',
            'The total weight of all the fat in your body, measured in kilograms'),
      ],
    );
  }
}
