import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/helpers.dart';
import 'package:workout_guide/models/workout.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/workout_exercises_screen.dart';
import 'package:workout_guide/widgets/dropdown_container.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const route = "/edit-workout";

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  double _approxHours = 0;
  double _approxMins = 0;
  Duration _approxDuration = Duration(
    hours: 0,
    minutes: 0,
  );
  var _date;
  Difficulty _difficulty;
  String _selDifficulty;
  WorkoutType _workoutType;
  String _selWorkoutType;
  String _equipment;
  List<String> _exerciseIds;
  String _title;
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isInit = true;
  Workout _editedObj;
  bool _isUpdate = false;
  String workoutId;
  ValueKey<DateTime> forceRebuild;
  ValueKey<DateTime> forceRebuild1;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      workoutId = ModalRoute.of(context).settings.arguments as String;
      if (workoutId != null) {
        _isUpdate = true;
        _editedObj = Provider.of<Workouts>(context, listen: false)
            .getWorkoutById(workoutId);
        _title = _editedObj.title;
        _selDifficulty = _editedObj.difficultyString;
        _difficulty = _editedObj.difficulty;

        Map<String, int> durationMap =
            Helpers.durationHelper(_editedObj.approxDuration);
        if (durationMap != null) {
          setState(() {
            _approxHours = durationMap["hours"].toDouble();
            _approxMins = durationMap["minutes"].toDouble() / 15;
            forceRebuild = ValueKey(DateTime.now());
            forceRebuild1 = ValueKey(DateTime.now());
          });

        } else {
          setState(() {
          _approxHours = 0.0;
          _approxMins = 0.0;
          });
        }

        _equipment = _editedObj.equipment;
        _date = _editedObj.dateTime;
        _selWorkoutType = _editedObj.workoutTypeString;
        _workoutType = _editedObj.workoutType;
        _exerciseIds = _editedObj.exerciseIds;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _presentDateAndTimePicker(BuildContext context) async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (dt != null) {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (t != null) {
        setState(() {
          _date = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
        });
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    const List<String> difficultyList = [
      "Easy",
      "Medium",
      "Hard",
    ];

    const List<String> workoutTypes = [
      "Mixed",
      "Rep based",
      "Time based",
    ];

    void setDifficulty(String value) {
      if (value.isNotEmpty) {
        setState(() {
          _selDifficulty = value;

          if (value == "Easy") {
            _difficulty = Difficulty.Easy;
          } else if (value == "Medium") {
            _difficulty = Difficulty.Medium;
          } else {
            _difficulty = Difficulty.Hard;
          }
        });
      }
    }

    void setWorkoutType(String value) {
      if (value.isNotEmpty) {
        setState(() {
          _selWorkoutType = value;

          if (value == "Mixed") {
            _workoutType = WorkoutType.Mixed;
          } else if (value == "Rep based") {
            _workoutType = WorkoutType.RepOnly;
          } else {
            _workoutType = WorkoutType.TimeOnly;
          }
        });
      }
    }

    void goToExercisesScreen(BuildContext context, String id) {
      Navigator.of(context)
          .pushReplacementNamed(WorkoutExercisesScreen.route, arguments: id);
    }

    Future<void> _saveForm(BuildContext context) async {
      setState(() {
        _isLoading = true;
      });
      _approxDuration = Duration(
        hours: _approxHours.toInt(),
        minutes: _approxMins.toInt() * 15,
      );

      List<String> errors = [];

      if (_date == null) {
        errors.add("Date");
      }

      if (_difficulty == null) {
        errors.add("Difficulty");
      }

      if (_workoutType == null) {
        errors.add("Workout type");
      }

      if (_approxDuration.inHours == 0 && _approxDuration.inMinutes == 0) {
        errors.add("Approximate duration");
      }

      if (errors.length > 0) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Check following fields"),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: Text("Close"),
              )
            ],
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errors.map((err) => Text("- $err")).toList(),
              ),
            ),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      } else {
        final isFormValid = _form.currentState.validate();
        if (isFormValid) {
          _form.currentState.save();
          Workout workout = Workout(
            dateTime: _date,
            difficulty: _difficulty,
            id: workoutId == null ? DateTime.now().toString() : workoutId,
            approxDuration: _approxDuration,
            equipment: _equipment,
            title: _title,
            workoutType: _workoutType,
            exerciseIds: _exerciseIds,
          );

          if (_isUpdate) {
            //patch request
            var status = await Provider.of<Workouts>(context, listen: false)
                .updateWorkout(workout.id, workout);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      status
                          ? Icon(Icons.check, color: Colors.green)
                          : Icon(Icons.close, color: Colors.red),
                      Text(status ? "Success" : "Error"),
                    ],
                  ),
                ),
                duration: Duration(seconds: 3),
                elevation: 10,
              ),
            );
            Navigator.of(context).pop();
          } else {
            final newId = await Provider.of<Workouts>(context, listen: false)
                .addWorkout(workout);

            if (newId != null) {
              setState(() {
                _isLoading = false;
              });
              goToExercisesScreen(context, newId);
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: !_isLoading
          ? SingleChildScrollView(
              child: Form(
                key: _form,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _title ?? "",
                        onSaved: (value) => _title = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter title";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    Text(
                                      "${_date == null ? "Please pick date" : DateFormat("EEEE - HH:mm").format(_date)}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    OutlinedButton(
                                      onPressed: () =>
                                          _presentDateAndTimePicker(context),
                                      child: Text("Select date and time"),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Text("Approximate duration"),
                              Text(
                                "${_approxHours.toInt()}h ${_approxMins.toInt() * 15}min",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Container(
                                key: forceRebuild,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("hours"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Slider(
                                        activeColor: _approxHours < 2
                                            ? Colors.green
                                            : _approxHours == 2
                                                ? Colors.orange
                                                : Colors.red,
                                        label: "${_approxHours.toInt()}",
                                        value: _approxHours,
                                        divisions: 3,
                                        min: 0,
                                        max: 3,
                                        onChanged: (val) {
                                          setState(() {
                                            _approxHours = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                key: forceRebuild1,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("mins"),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: Slider(
                                        label: "${(_approxMins * 15).toInt()}",
                                        value: _approxMins,
                                        divisions: 3,
                                        min: 0,
                                        max: 3,
                                        onChanged: (val) {
                                          setState(() {
                                            _approxMins = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Text("Difficulty"),
                              DropdownContainer(
                                hint: "Difficulty",
                                items: difficultyList,
                                value: _selDifficulty,
                                onDropdownSelect: setDifficulty,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Text("Workout type"),
                              DropdownContainer(
                                hint: "Workout type",
                                value: _selWorkoutType,
                                items: workoutTypes,
                                onDropdownSelect: setWorkoutType,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
                                  initialValue: _equipment ?? "",
                                  onSaved: (value) => _equipment = value,
                                  keyboardType: TextInputType.multiline,
                                  autocorrect: false,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      labelText: "Equipment",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                alignment: AlignmentDirectional.centerEnd,
                                child: TextButton(
                                  onPressed: () => _saveForm(context),
                                  child: Text(_isUpdate ? "Save" : "Save and add exercises"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
