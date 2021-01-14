import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final List<String> exceptions;

  ErrorView(this.error, this.exceptions);

  @override
  Widget build(BuildContext context) {
    // We do not recognize your username and/or password. Please try again.
    if (error.isNotEmpty || exceptions.length > 0) {
      return Column(children: <Widget>[
        Text('Error: $error',
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).errorColor,
            )),
        if (exceptions.length > 0) ...[_showExceptions(context)]
      ]);
    } else {
      return Container();
    }
  }

  _showExceptions(context) {
    return Column(
        children: exceptions
            .map((item) => new Text(item + " ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).errorColor,
                )))
            .toList());
  }
}
