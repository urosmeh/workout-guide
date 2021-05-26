import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/auth_screen.dart';
import 'package:workout_guide/screens/workout_exercises_screen.dart';
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
        ChangeNotifierProxyProvider<Auth, Workouts>(
          update: (ctx, auth, previousWorkouts) => Workouts(
            auth.token,
            auth.userId,
            previousWorkouts == null ? [] : previousWorkouts.workouts,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Exercises>(
          update: (ctx, auth, previousExercises) => Exercises(
            auth.token,
            auth.userId,
            previousExercises == null ? [] : previousExercises.exercises,
          ),
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
            routes: {
              EditWorkoutScreen.route: (ctx) => EditWorkoutScreen(),
              WorkoutsScreen.route: (ctx) => WorkoutsScreen(),
              AuthScreen.route: (ctx) => AuthScreen(),
              WorkoutExercisesScreen.route: (ctx) =>
                  WorkoutExercisesScreen(),
                  //AddWorkoutExerciseModal.route: (ctx) => AddWorkoutExerciseModal(),
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
