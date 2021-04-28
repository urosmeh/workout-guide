import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/screens/auth_screen.dart';
import 'package:workout_guide/screens/workouts_screen.dart';

import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
            title: "Workout guide",
            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.deepOrange,
            ),
            home: auth.isAuth
                ? WorkoutsScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authRes) =>
                        authRes.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : AuthScreen(),
                  ),
          );
        },
      ),
    );
    // return MaterialApp(
    //   title: "Workout guide",
    //   home: AuthScreen(),
    //   theme: ThemeData(
    //     primarySwatch: Colors.pink,
    //     accentColor: Colors.deepOrange,
    //   ),
    // );
  }
}
