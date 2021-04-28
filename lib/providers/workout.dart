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
  String title;
  List<Exercise> exercises;
  DateTime dateTime;
  String equipment;
  Duration approxDuration;
  int kcalBurned;
  WorkoutType workoutType;
  Difficulty difficulty;
  bool isFinished;

  Workout({
    @required this.title,
    @required this.exercises,
    @required this.dateTime,
    this.equipment = "No equipment needed",
    this.approxDuration,
    this.kcalBurned,
    @required this.workoutType,
    @required this.difficulty,
    this.isFinished = false,
  });
}
