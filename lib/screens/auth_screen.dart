import 'package:flutter/material.dart';
import 'package:workout_guide/widgets/login_background.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LoginBackground(),
          Container(
            alignment: Alignment.center,
            height: 400,
            child: Card(
              elevation: 5,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("test"),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
