import 'package:flutter/foundation.dart';
import 'package:workout_guide/models/exercise.dart';

enum WorkoutType {
  RepOnly,
  TimeOnly,
  Mixed,
}

enum Difficulty {
  Easy,
  Medium,
  Hard,
}

class Workout with ChangeNotifier {
  String id;
  String title;
  List<String> exerciseIds;
  DateTime dateTime;
  Duration approxDuration;
  String equipment;
  int kcalBurned;
  WorkoutType workoutType;
  Difficulty difficulty;
  bool isFinished;

  Workout({
    this.id,
    @required this.title,
    this.exerciseIds,
    @required this.dateTime,
    this.equipment = "No equipment needed",
    this.approxDuration,
    this.kcalBurned,
    @required this.workoutType,
    @required this.difficulty,
    this.isFinished = false,
  });

  String get workoutTypeString {
    if (this.workoutType == WorkoutType.Mixed) {
      return "Mixed";
    } else if (this.workoutType == WorkoutType.RepOnly) {
      return "RepOnly";
    } else
      return "TimeOnly";
  }

  String get difficultyString {
    if (this.difficulty == Difficulty.Easy) {
      return "Easy";
    } else if (this.difficulty == Difficulty.Medium) {
      return "Medium";
    } else
      return "Hard";
  }

  String get approxDurationString {
    if (approxDuration == null) {
      return "Duration not provided";
    }
    int mins = approxDuration.inMinutes;

    int hoursOnly = mins ~/ 60;
    int minutesOnly = mins - hoursOnly * 60;

    return "${hoursOnly}h ${minutesOnly}m";
  }

  void addExercise(String exerciseId) {
    if(exerciseIds != null) {
      exerciseIds.add(exerciseId);
    } else {
      exerciseIds = [exerciseId];
    }
    notifyListeners();
  }
}
