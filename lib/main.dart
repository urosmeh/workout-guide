import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/auth_screen.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => Workouts()),
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
            routes: {
              EditWorkoutScreen.route: (ctx) => EditWorkoutScreen(),
              WorkoutsScreen.route: (ctx) => WorkoutsScreen(),
              AuthScreen.route: (ctx) => AuthScreen(),
            },
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
