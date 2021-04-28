import 'package:flutter/foundation.dart';

enum ExerciseType {
  RepBased,
  TimeBased,
}

class Exercise {
  String id;
  String title;
  String description;
  ExerciseType type;
  var duration;
  int reps;

  Exercise({
    @required this.id,
    @required this.title,
    this.description,
    @required this.type,
    this.duration,
    this.reps,
  });
}
