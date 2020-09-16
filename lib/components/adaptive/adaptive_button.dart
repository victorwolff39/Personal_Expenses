import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final bool isIOS = Platform.isIOS;

  final String label;
  final Function onPressed;

  AdaptiveButton({
    this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isIOS
        ? CupertinoButton(
            color: Theme.of(context).primaryColor,
            child: Text(label),
            onPressed: onPressed,
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
          )
        : RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).textTheme.button.color,
            child: Text(label),
            onPressed: onPressed,
          );
  }
}
