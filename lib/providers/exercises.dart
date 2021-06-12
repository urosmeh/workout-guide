import 'package:flutter/foundation.dart';
import 'package:workout_guide/db_urls.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:http/http.dart' as http;
import 'package:workout_guide/models/helpers.dart';
import 'dart:convert';

class Exercises with ChangeNotifier, Helpers {
  final String authToken;
  final String userId;
  List<Exercise> _exercises = [];

  Exercises(this.authToken, this.userId, this._exercises);

  Future<String> addExercise(Exercise ex) async {
    final url = Uri.parse("${FIREBASE_URL}exercises.json?auth=$authToken");
    final response = await http.post(
      url,
      body: json.encode({
        "title": ex.title,
        "description": ex.description,
        "exerciseType": Helpers.exerciseTypeString(ex.type),
        "duration": Helpers.durationHelper(ex.duration),
        "reps": ex.reps,
        "userCreated": userId,
      }),
    );

    var id = json.decode(response.body)["name"];
    ex.id = id;

    _exercises.add(ex);
    notifyListeners();

    return id;
  }

  List<Exercise> get exercises {
    return _exercises;
  }

  Future<void> getAndSetExercises() async {
    final filterString = 'orderBy="userCreated"&equalTo="$userId"';
    final url = Uri.parse(
        "${FIREBASE_URL}exercises.json?auth=$authToken&$filterString");

    try {
      final response = await http.get(url);
      final rData = json.decode(response.body) as Map<String, dynamic>;
      final List<Exercise> exercises = [];

      if (rData == null) {
        notifyListeners();
        return;
      }

      rData.forEach((id, exercise) {
        var durationMap = exercise["duration"] as Map<dynamic, dynamic>;
        var duration = Duration(
          hours: durationMap["hours"],
          minutes: durationMap["minutes"],
        );

        exercises.add(
          Exercise(
            id: id,
            title: exercise["title"],
            description: exercise["description"],
            type: Helpers.getETFromString(exercise["type"]),
            reps: exercise["reps"],
            duration: duration,
          ),
        );
      });
      _exercises = exercises;
      notifyListeners();
      //return exercises;
    } catch (error) {
      throw error;
    }
  }

  // Future<List<Exercise>> getExercisesByIds(List<String> ids) async {
  //   await getAndSetExercises();
  //   return exercises.where((item) => ids.contains(item.id)).toList();
  // }

  List<Exercise> getExercisesByIds(List<String> ids) {
    print("prov: $ids");
    List<Exercise> tmp =
        exercises.where((item) => ids.contains(item.id)).toList();

    // tmp.sort((a, b) => ids.indexOf(a.) - ids.indexOf(b));
    //var sortItem = tmp[0];
    List<Exercise> sorted = [];
    for (int i = 0; i < tmp.length; i++) {
      sorted.add(tmp.firstWhere((item) => item.id == ids[i]));
    }
    return sorted;
  }

  Exercise getExerciseById(String id) {
    return exercises.firstWhere((exercise) => id == exercise.id);
  }
}
