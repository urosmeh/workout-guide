import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(colors: [
        Colors.black12,
        Colors.black45,
      ]).createShader(bounds),
      blendMode: BlendMode.darken,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login-bg.jpg'),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(Colors.black12, BlendMode.darken)),
        ),
      ),
    );
  }
}
