import 'package:workout_guide/models/exercise.dart';

class Helpers {
  static String approxDurationString(Duration approxDuration) {
    if (approxDuration == null) {
      return "Duration not provided";
    }
    int mins = approxDuration.inMinutes;

    int hoursOnly = mins ~/ 60;
    int minutesOnly = mins - hoursOnly * 60;

    return "${hoursOnly}h ${minutesOnly}m";
  }

  static String exerciseTypeString(ExerciseType et) {
    if (et == ExerciseType.RepBased) {
      return "RepBased";
    } else {
      return "TimeBased";
    }
  }

  static ExerciseType getETFromString(String et) {
    if (et == "RepBased") {
      return ExerciseType.RepBased;
    } else {
      return ExerciseType.TimeBased;
    }
  }
}

// TODO: add helpers
