import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:workout_guide/db_urls.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/http_exception.dart';
import '../models/workout.dart';
import 'package:http/http.dart' as http;

class Workouts with ChangeNotifier {
  final String authToken;
  final String userId;

  Workouts(this.authToken, this.userId, this._workouts);

  List<Workout> _workouts = [];

  List<Workout> get workouts {
    return _workouts;
  }

  Difficulty getDiffFromString(String diff) {
    if (diff == "Easy") {
      return Difficulty.Easy;
    } else if (diff == "Medium") {
      return Difficulty.Medium;
    } else {
      return Difficulty.Hard;
    }
  }

  WorkoutType getWTFromString(String wt) {
    if (wt == "RepOnly") {
      return WorkoutType.RepOnly;
    } else if (wt == "TimeOnly") {
      return WorkoutType.TimeOnly;
    } else {
      return WorkoutType.Mixed;
    }
  }

  Map<String, int> durationHelper(Duration d) {
    int mins = d.inMinutes;
    int hoursOnly = mins ~/ 60;
    int minsOnly = mins - hoursOnly * 60;
    return {"minutes": minsOnly, "hours": hoursOnly};
  }

  ExerciseType getETFromString(String et) {
    if (et == "RepBased") {
      return ExerciseType.RepBased;
    } else {
      return ExerciseType.TimeBased;
    }
  }

  Workout getWorkoutById(String id) {
    return _workouts.firstWhere((item) => item.id == id);
  }

  Future<String> addWorkout(Workout workout) async {
    final url = Uri.parse("${FIREBASE_URL}workouts.json?auth=$authToken");

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
        "userCreated": userId,
        "exerciseIds": [],
      }),
    );

    var id = json.decode(response.body)["name"];
    workout.id = id;

    _workouts.add(workout);
    notifyListeners();

    return id;
  }

  Future<void> removeWorkout(String id) async {
    final url = Uri.parse("${FIREBASE_URL}workouts/$id.json?auth=$authToken");
    var existingIndex = _workouts.indexWhere((workout) => workout.id == id);
    var existingWorkout = _workouts[existingIndex];

    _workouts.removeAt(existingIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      //on error, reinsert
      _workouts.insert(existingIndex, existingWorkout);
      notifyListeners();
      throw HttpException("Couldn't delete workout");
    } else {
      existingWorkout = null;
      notifyListeners();
    }
  }

  Future<void> getAndSetWorkouts() async {
    final filterString = 'orderBy="userCreated"&equalTo="$userId"';
    final url =
        Uri.parse("${FIREBASE_URL}workouts.json?auth=$authToken&$filterString");

    try {
      final response = await http.get(url);
      final rData = json.decode(response.body) as Map<String, dynamic>;
      if (rData == null) {
        return;
      }

      final List<Workout> workouts = [];

      rData.forEach((id, workout) {
        var durationMap = workout["approxDuration"] as Map<dynamic, dynamic>;
        var duration = Duration(
          hours: durationMap["hours"],
          minutes: durationMap["minutes"],
        );
        //Map<String, String> exerciseIds = workout["exerciseIds"] as Map<String, String>;
        List<String> exerciseIds =
            List.castFrom(workout["exerciseIds"] as List ?? []);

        workouts.add(
          Workout(
            id: id,
            title: workout["title"],
            dateTime: DateTime.parse(workout["dateTime"]),
            difficulty: getDiffFromString(workout["difficulty"]),
            workoutType: getWTFromString(workout["workoutType"]),
            equipment: workout["equipment"],
            approxDuration: duration,
            exerciseIds: exerciseIds,
          ),
        );
        workouts.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      });
      _workouts = workouts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> addExerciseToWorkout(String workoutId, String exerciseId) async {
    if (workoutId == null) {
      return false;
    }

    if (workoutId.isEmpty || exerciseId.isEmpty) {
      return false;
    }

    final url =
        Uri.parse("${FIREBASE_URL}workouts/$workoutId.json?auth=$authToken");

    final wIndex = _workouts.indexWhere((item) => workoutId == item.id);
    var workout = _workouts[wIndex];
    if (workout.exerciseIds == null) {
      workout.exerciseIds = [exerciseId];
    } else {
      workout.exerciseIds.add(exerciseId);
    }
    notifyListeners();

    try {
      await http.patch(
        url,
        body: json.encode(
          {
            "title": workout.title,
            "approxDuration": durationHelper(workout.approxDuration),
            "dateTime": workout.dateTime.toIso8601String(),
            "kcalBurned": workout.kcalBurned,
            "equipment": workout.equipment,
            "workoutType": workout.workoutTypeString,
            "difficulty": workout.difficultyString,
            "isFinished": false,
            "userCreated": userId,
            "exerciseIds": workout.exerciseIds,
          },
        ),
      );
    } catch (error) {
      throw error;
    }

    notifyListeners();
    return true;
  }

  Future<bool> updateWorkout(String workoutId, Workout workout) async {
    final url =
        Uri.parse("${FIREBASE_URL}workouts/$workoutId.json?auth=$authToken");
    final workoutIndex = _workouts.indexWhere((item) => workoutId == item.id);

    if (workoutIndex >= 0) {
      _workouts[workoutIndex] = workout;
      //return true;
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              "title": workout.title,
              "approxDuration": durationHelper(workout.approxDuration),
              "dateTime": workout.dateTime.toIso8601String(),
              "kcalBurned": workout.kcalBurned ?? 0,
              "equipment": workout.equipment,
              "workoutType": workout.workoutTypeString,
              "difficulty": workout.difficultyString,
              "isFinished":
                  workout.isFinished == null ? false : workout.isFinished,
              "userCreated": userId,
              "exerciseIds": workout.exerciseIds,
            },
          ),
        );
        notifyListeners();
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> patchWOExercises(String workoutId, List<String> newExercisesOrder) async {
    final url =
        Uri.parse("${FIREBASE_URL}workouts/$workoutId.json?auth=$authToken");
    final workoutIndex = _workouts.indexWhere((item) => workoutId == item.id);
    var workout = _workouts[workoutIndex];

    if (workoutIndex >= 0) {
      try {
        await http.patch(
          url,
          body: json.encode(
            {
              "title": workout.title,
              "approxDuration": durationHelper(workout.approxDuration),
              "dateTime": workout.dateTime.toIso8601String(),
              "kcalBurned": workout.kcalBurned ?? 0,
              "equipment": workout.equipment,
              "workoutType": workout.workoutTypeString,
              "difficulty": workout.difficultyString,
              "isFinished":
                  workout.isFinished == null ? false : workout.isFinished,
              "userCreated": userId,
              "exerciseIds": newExercisesOrder,
            },
          ),
        );
        notifyListeners();
        return true;
      } catch (error) {
        return false;
      }
    } else {
      return false;
    }
  }
}
