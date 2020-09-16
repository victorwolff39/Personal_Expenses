import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptiveDatepicker extends StatelessWidget {
  final bool isIOS = Platform.isIOS;

  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  AdaptiveDatepicker({
    this.selectedDate,
    this.onDateChanged,
    this.initialDate,
    this.firstDate,
    this.lastDate
  });

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      /*
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.now(),
       */
    ).then((pickedDate) {
      //when the datepicker is closed, THEN it will run this function...
      if (pickedDate == null) {
        return;
      } else {
        onDateChanged(pickedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isIOS
        ? Container(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2018),
              maximumDate: DateTime.now(),
              onDateTimeChanged: onDateChanged,
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                selectedDate == null
                    ? Expanded(
                        child: Text(
                          "Nenhuma data selecionada.",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Expanded(
                        child: Text(
                          "Data selecionada: ${DateFormat("d/MM/y").format(selectedDate)}",
                        ),
                      ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _showDatePicker(context),
                ),
              ],
            ),
          );
  }
}
