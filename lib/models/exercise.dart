import 'package:flutter/foundation.dart';

enum ExerciseType {
  RepBased,
  TimeBased,
}

class Exercise with ChangeNotifier {
  String id;
  String title;
  String description;
  ExerciseType type;
  Duration duration;
  int reps;

  Exercise({
    this.id,
    @required this.title,
    this.description,
    @required this.type,
    this.duration,
    this.reps,
  });
}
