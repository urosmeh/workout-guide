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
  List<Exercise> exercises;
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
    this.exercises,
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
    int hours = approxDuration.inHours;
    int mins = approxDuration.inMinutes;

    if (hours > 0) {
      if (approxDuration.inMinutes > 0) {
        return "${hours}h ${mins}m";
      } else {
        return "${hours}h";
      }
    } else {
      if (mins > 0) {
        return "${mins}min";
      } else {
        return "Duration not provided";
      }
    }
  }
}
