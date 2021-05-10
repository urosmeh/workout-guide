import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:workout_guide/db_urls.dart';
import 'package:workout_guide/models/exercise.dart';
import 'workout.dart';
import 'package:http/http.dart' as http;

class Workouts with ChangeNotifier {
  final String authToken;
  final String userId;

  Workouts(this.authToken, this.userId, this._workouts);

  List<Workout> _workouts = [
    Workout(
        title: "Full body",
        exercises: [
          Exercise(
            id: "e1",
            title: "Run in place",
            type: ExerciseType.TimeBased,
            description: "Just run in place for time given",
            duration: Duration(
              seconds: 30,
            ),
          ),
          Exercise(
            id: "e2",
            title: "Jumping jacks",
            type: ExerciseType.TimeBased,
            description:
                "Jump with legs spread wide and hands overhead, then return in position with feet together and arms at sides",
            duration: Duration(
              minutes: 1,
            ),
          ),
          Exercise(
            id: "e3",
            title: "Squats",
            type: ExerciseType.RepBased,
            description:
                "Squat with flat back, knees always behind toes, to 90degrees",
            reps: 20,
          ),
          Exercise(
            id: "e4",
            title: "Lunges",
            type: ExerciseType.RepBased,
            description: "Jump with crossing lets front/back, same with arms",
            reps: 20,
          ),
          Exercise(
            id: "e5",
            title: "Burpees",
            type: ExerciseType.RepBased,
            description: "Squat, push-up, jump, repeat",
            reps: 20,
          ),
        ],
        dateTime: DateTime.now(),
        approxDuration: Duration(
          minutes: 10,
        ),
        workoutType: WorkoutType.Mixed,
        difficulty: Difficulty.Hard),
    Workout(
        title: "Not full body",
        exercises: [
          Exercise(
            id: DateTime.now().toString(),
            title: "Run in place",
            type: ExerciseType.TimeBased,
            description: "Just run in place for time given",
            duration: Duration(
              seconds: 30,
            ),
          ),
          Exercise(
            id: DateTime.now().toString(),
            title: "Jumping jacks",
            type: ExerciseType.TimeBased,
            description:
                "Jump with legs spread wide and hands overhead, then return in position with feet together and arms at sides",
            duration: Duration(
              minutes: 1,
            ),
          ),
          Exercise(
            id: DateTime.now().toString(),
            title: "Squats",
            type: ExerciseType.RepBased,
            description:
                "Squat with flat back, knees always behind toes, to 90degrees",
            reps: 20,
          ),
          Exercise(
            id: DateTime.now().toString(),
            title: "Lunges",
            type: ExerciseType.RepBased,
            description: "Jump with crossing lets front/back, same with arms",
            reps: 20,
          ),
          Exercise(
            id: DateTime.now().toString(),
            title: "Burpees",
            type: ExerciseType.RepBased,
            description: "Squat, push-up, jump, repeat",
            reps: 20,
          ),
        ],
        dateTime: DateTime(2021, 5, 20, 13, 30),
        approxDuration: Duration(
          minutes: 70,
        ),
        workoutType: WorkoutType.Mixed,
        difficulty: Difficulty.Easy,
        equipment: "Dumbells, mat")
  ];

  List<Workout> get workouts {
    return _workouts;
  }

  Map<String, int> durationHelper (Duration d){
    int mins = d.inMinutes;
    int hoursOnly = mins ~/ 60;
    int minsOnly = mins - hoursOnly * 60;

    return {
      "minutes": minsOnly,
      "hours": hoursOnly
    };
  }

  Future<void> addWorkout(Workout workout) async {
    print("addworkout");
    final url = Uri.parse("${FIREBASE_URL}workouts.json?auth=$authToken");
    print(url.toString());
    final response = await http.post(
      url,
      body: json.encode({
        "title": workout.title,
        "approxDuration": durationHelper(workout.approxDuration),
        "dateTime": workout.dateTime.toIso8601String(),
        "kcalBurned": 0,
        "equipment": workout.equipment,
        "workoutType": workout.workoutTypeString,
        "difficulty": workout.difficultyString,
        "isFinished": false,
      }),
    );
    print(response.body);
    workout.id = json.decode(response.body)["name"];
    _workouts.add(workout);
    notifyListeners();
  }

  // void addWorkout(Workout workout) {
  //   _workouts.add(workout);
  //   notifyListeners();
  // }
}
