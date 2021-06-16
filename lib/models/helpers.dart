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
    int h = d.inHours.remainder(24);
    int m = d.inMinutes.remainder(60);
    int s = d.inSeconds.remainder(60);

    return {"hours": h, "minutes": m, "seconds": s};
  }

  static String durationString(Duration d) {
    var dMap = durationHelper(d);
    return "${dMap["hours"]}h ${dMap["minutes"]}m ${dMap["seconds"]}s";
  }
}