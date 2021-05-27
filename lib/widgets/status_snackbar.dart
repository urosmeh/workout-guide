import 'package:flutter/material.dart';

class StatusSnackbar extends SnackBar {
  final context;
  final messageOk;
  final messageError;
  final status;

  StatusSnackbar({
    @required this.context,
    @required this.messageOk,
    @required this.messageError,
    @required this.status,
  });

  Widget build(context) {
    return SnackBar(
      content: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            status
                ? Icon(Icons.check, color: Colors.green)
                : Icon(Icons.close, color: Colors.red),
            Text(status ? messageOk : messageError),
          ],
        ),
      ),
      duration: Duration(seconds: 3),
      elevation: 10,
    );
  }
}
