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
        "duration": Helpers.approxDurationString(ex.duration),
        "reps": ex.reps,
      }),
    );

    var id = json.decode(response.body)["name"];
    ex.id = id;

    _exercises.add(ex);
    notifyListeners();

    return id;
  }

  Future<void> getAndSetExercises() async {
    final filterString = 'orderBy="userCreated"&equalTo="$userId"';
    final url = Uri.parse(
        "${FIREBASE_URL}exercises.json?auth=$authToken&$filterString");

    try {
      final response = await http.get(url);
      final rData = json.decode(response.body) as Map<String, dynamic>;

      if (rData == null) {
        return;
      }

      final List<Exercise> exercises = [];

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
      
    } catch (error) {
      throw error;
    }
  }
}
