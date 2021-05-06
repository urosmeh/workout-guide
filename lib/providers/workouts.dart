import 'package:flutter/foundation.dart';
import 'workout.dart';

class Workouts with ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get workouts {
    return _workouts;
  }

  void addWorkout(Workout workout) {
    _workouts.add(workout);
    notifyListeners();
  }
  //Workouts(this._workouts);
}
