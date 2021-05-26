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

  static Map<String, int> durationHelper(Duration d) {
    int mins = d.inMinutes;
    int hoursOnly = mins ~/ 60;
    int minsOnly = mins - hoursOnly * 60;

    print("duration obj:  ${d.toString()}");
    print("hours:  $hoursOnly");
    print("hours:  $minsOnly");

    return {"minutes": minsOnly, "hours": hoursOnly};
  }
}

// TODO: add helpers
