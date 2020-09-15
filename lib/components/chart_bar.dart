import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final double value;
  final String day;
  final double percentage;

  ChartBar({
    this.day,
    this.value,
    this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 20,
          child: FittedBox(
            child: Text("R\$"),
          ),
        ),
        Container(
          height: 20,
          child: FittedBox(
            child: Text(" ${value.toStringAsFixed(2)}"),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 60,
          width: 10,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 0.5),
                    borderRadius: BorderRadius.circular(5)),
              ),
              FractionallySizedBox(
                heightFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                ),
              )
            ],
          ),
        ),
        Text(day)
      ],
    );
  }
}
