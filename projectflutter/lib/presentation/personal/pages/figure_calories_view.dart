import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectflutter/common/widget/appbar/app_bar.dart';

class FigureCaloriesView extends StatefulWidget {
  const FigureCaloriesView({super.key});

  @override
  State<FigureCaloriesView> createState() => _FigureCaloriesViewState();
}

class _FigureCaloriesViewState extends State<FigureCaloriesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: const Text('Figures',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
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
