import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class FigureAbsorbView extends StatefulWidget {
  const FigureAbsorbView({super.key});

  @override
  State<FigureAbsorbView> createState() => _FigureAbsorbViewState();
}

class _FigureAbsorbViewState extends State<FigureAbsorbView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text('Figure Absorb'),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text('Figure Chart'),
                ),
                Center(
                  child: Text('Figure Calories'),
                ),
                Center(
                  child: Text('Figure Details'),
                )
              ],
            ),
          ),
        )
    );
  }
}
