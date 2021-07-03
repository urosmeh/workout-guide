import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/http_exception.dart';
import 'package:workout_guide/providers/auth.dart';
import 'package:workout_guide/widgets/login_background.dart';

enum AuthType {
  Login,
  Signup,
}

class AuthScreen extends StatelessWidget {
  static const route = "/auth";
  AuthScreen();

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

class _FormContainerState extends State<FormContainer>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthType _authType = AuthType.Login;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  var icon = Icons.close;
  var _isLoading = false;

  final _passwordController = TextEditingController();

  void _switchAuthType() {
    if (_authType == AuthType.Login) {
      setState(() {
        _authType = AuthType.Signup;
        _controller.forward();
      });
    } else {
      setState(() {
        _authType = AuthType.Login;
        _controller.reverse();
      });
    }
    // setState(() {
    //   _authType =
    //       _authType == AuthType.Login ? AuthType.Signup : AuthType.Login;
    // });
  }

  bool _validEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Authentication failed!"),
        content: Text(message),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          )
        ],
      ),
    );
  }

  void _submitForm() async {
    setState(() {
      _isLoading = true;
    });
    if (!_formKey.currentState.validate()) {
      //FirebaseMessaging.instance
      return;
    }

    _formKey.currentState.save();

    try {
      if (_authType == AuthType.Login) {
        await Provider.of<Auth>(context, listen: false).login(
          _authData["email"],
          _authData["password"],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData["email"],
          _authData["password"],
        );
      }
    } on HttpException catch (error) {
      String errMsg = "Authentication failed";

      if (error.toString().contains("EMAIL_EXISTS")) {
        errMsg = "Email already exists!";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errMsg = "Invalid email address!";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errMsg = "This password is too weak";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errMsg = "User with email not found";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errMsg = "Incorrect password";
      }

      _showErrorDialog(errMsg);
    } catch (error) {
      const errMsg = "Couldn't authenticate";
      _showErrorDialog(errMsg);
    }
  }

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _opacityAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 1,
        color: Colors.transparent.withOpacity(.4),
        child: Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints(
              minHeight: _authType == AuthType.Login ? 100 : 20,
            ),
            child: !_isLoading ? Column(
              children: [
                TextFormField(
                  validator: (value) {
                    return !_validEmail(value)
                        ? "Email format incorrect"
                        : null;
                  },
                  onSaved: (value) => _authData["email"] = value,
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
                  validator: (value) {
                    return value.length < 6
                        ? "password should have atleast 6 characters!"
                        : null;
                  },
                  onSaved: (value) => _authData["password"] = value,
                  controller: _passwordController,
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authType == AuthType.Signup ? 60 : 0,
                    maxHeight: _authType == AuthType.Signup ? 100 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authType == AuthType.Signup,
                        decoration: InputDecoration(
                          labelText: "confirm password",
                          labelStyle: TextStyle(color: Colors.white70),
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Icon(
                              icon,
                              color: icon == Icons.check_sharp
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onFieldSubmitted: (value) {
                          setState(() {
                            icon = value == _passwordController.text
                                ? Icons.check_sharp
                                : Icons.close;
                          });
                        },
                        validator: _authType == AuthType.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _submitForm(),
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
            ) : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
