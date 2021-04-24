import 'package:flutter/material.dart';
import 'package:workout_guide/widgets/login_background.dart';

enum AuthType {
  Login,
  Signup,
}

class AuthScreen extends StatelessWidget {
  static const route = "/auth";
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          LoginBackground(),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black12,
                              Colors.black87,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0, 1],
                          ),
                        ),
                        child: Text(
                          "Workout Guide",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  FormContainer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FormContainer extends StatefulWidget {
  @override
  _FormContainerState createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthType _authType = AuthType.Login;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  void _switchAuthType() {
    setState(() {
      _authType =
          _authType == AuthType.Login ? AuthType.Signup : AuthType.Login;
    });
  }

  bool _validEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 1,
        color: Colors.transparent.withOpacity(.4),
        child: Form(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            constraints: BoxConstraints(
                minHeight: _authType == AuthType.Login ? 100 : 20),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "email",
                    labelStyle: TextStyle(color: Colors.white70),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(Icons.email),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  validator: (value) {},
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "password",
                    labelStyle: TextStyle(color: Colors.white70),
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(Icons.lock),
                    ),
                    border: InputBorder.none,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    _authType == AuthType.Login ? "Login" : "Signup",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () => _switchAuthType(),
                  child: Text(_authType == AuthType.Login
                      ? "Create new account"
                      : "Use existing account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
