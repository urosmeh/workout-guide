import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  String _title;

  final _form = GlobalKey<FormState>();

  bool isLoading = false;

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
        isLoading = true;
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
          isLoading = false;
        });
        return;
      } else {
        final isFormValid = _form.currentState.validate();
        if (isFormValid) {
          _form.currentState.save();
          Workout workout = Workout(
            dateTime: _date,
            difficulty: _difficulty,
            id: DateTime.now().toString(),
            approxDuration: _approxDuration,
            equipment: _equipment,
            title: _title,
            workoutType: _workoutType,
          );
          final newId = await Provider.of<Workouts>(context, listen: false)
              .addWorkout(workout);

          if (newId != null) {
            setState(() {
              isLoading = false;
            });
            goToExercisesScreen(context, newId);
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: !isLoading
          ? SingleChildScrollView(
              child: Form(
                key: _form,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
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
                                            print("val: $val");
                                            _approxHours = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
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
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   width: double.infinity,
                              //   child: DropdownButton(
                              //     underline: SizedBox(),
                              //     value: _selDifficulty,
                              //     onChanged: (value) {
                              //       print(value);
                              //       setDifficulty(value);
                              //     },
                              //     icon: Icon(Icons.arrow_drop_down_sharp),
                              //     elevation: 3,
                              //     isExpanded: true,
                              //     hint: Text("Difficulty"),
                              //     items: difficultyList
                              //         .map(
                              //           (item) => DropdownMenuItem(
                              //             value: item,
                              //             child: Text(item),
                              //           ),
                              //         )
                              //         .toList(),
                              //   ),
                              // ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Text("Workout type"),
                              DropdownContainer(
                                hint: "Workout type",
                                value: _selWorkoutType,
                                items: ["Mixed", "Rep based", "Time based"],
                                onDropdownSelect: setWorkoutType,
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.pink.shade100,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: TextFormField(
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
                                  child: Text("Save and add exercises"),
                                ),
                              ),
                              // Divider(
                              //   thickness: 1,
                              //   color: Colors.pink.shade100,
                              // ),
                              // Text("Exercises"),
                              // Container(
                              //   height: 200,
                              //   child: ReorderableListView.builder(
                              //     itemCount: workouts[0].exercises.length,
                              //     clipBehavior: Clip.antiAlias,

                              //     //notifier na exercise ??????
                              //     onReorder: (oldIndex, newIndex) {
                              //       final ex = workouts[0].exercises.removeAt(oldIndex);
                              //       print(
                              //           "old: ${oldIndex.toString()} new:${newIndex.toString()}");

                              //       workouts[0].exercises.insert(newIndex, ex);
                              //     },
                              //     buildDefaultDragHandles: true,
                              //     scrollDirection: Axis.horizontal,
                              //     itemBuilder: (context, index) {
                              //       return Container(
                              //         key: ValueKey(index),
                              //         width: 200,
                              //         child: Card(
                              //           clipBehavior: Clip.antiAlias,
                              //           elevation: 5,
                              //           child: Center(
                              //             child: Column(
                              //               children: [
                              //                 Flexible(
                              //                   fit: FlexFit.tight,
                              //                   flex: 1,
                              //                   child: Stack(
                              //                     children: [
                              //                       Container(
                              //                         decoration: BoxDecoration(
                              //                           gradient: LinearGradient(
                              //                             colors: [
                              //                               Colors.orange[200],
                              //                               Colors.orange[700],
                              //                             ],
                              //                           ),
                              //                         ),
                              //                       ),
                              //                       Center(
                              //                         child: Text(
                              //                             "ID: ${workouts[0].exercises[index].id} Exercise ${workouts[0].exercises[index].title}"),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //                 Flexible(
                              //                   fit: FlexFit.tight,
                              //                   flex: 2,
                              //                   child: Center(
                              //                     child: SingleChildScrollView(
                              //                       padding: EdgeInsets.all(10),
                              //                       child: Text(
                              //                         "${workouts[0].exercises[index].description}",
                              //                         textAlign: TextAlign.center,
                              //                         //maxLines: 4,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 Flexible(
                              //                   fit: FlexFit.tight,
                              //                   flex: 1,
                              //                   child: Center(
                              //                     child: Row(
                              //                       mainAxisAlignment:
                              //                           MainAxisAlignment.center,
                              //                       children: [
                              //                         ExerciseType.RepBased ==
                              //                                 workouts[0]
                              //                                     .exercises[index]
                              //                                     .type
                              //                             ? Text(workouts[0]
                              //                                 .exercises[index]
                              //                                 .reps
                              //                                 .toString())
                              //                             : Text(workouts[0]
                              //                                 .exercises[index]
                              //                                 .duration
                              //                                 .toString())
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //       );
                              //     },
                              // children: [
                              //   for (final ex in workouts[0].exercises)
                              //     Container(
                              //         key: ValueKey(Random(10)),
                              //         width: 200,
                              //       child: Card(
                              //         clipBehavior: Clip.antiAlias,
                              //         elevation: 5,
                              //         child: Center(
                              //           child: Column(
                              //             children: [
                              //               Flexible(
                              //                 fit: FlexFit.tight,
                              //                 flex: 1,
                              //                 child: Stack(
                              //                   children: [
                              //                     Container(
                              //                       decoration: BoxDecoration(
                              //                         gradient: LinearGradient(
                              //                           colors: [
                              //                             Colors.orange[200],
                              //                             Colors.orange[700],
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     Center(
                              //                       child: Text("Exercise ${ex.title}"),
                              //                     ),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Flexible(
                              //                 fit: FlexFit.tight,
                              //                 flex: 2,
                              //                 child: Center(
                              //                   child: SingleChildScrollView(
                              //                     padding: EdgeInsets.all(10),
                              //                     child: Text(
                              //                       "${ex.description}",
                              //                       textAlign: TextAlign.center,
                              //                       //maxLines: 4,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               Flexible(
                              //                 fit: FlexFit.tight,
                              //                 flex: 1,
                              //                 child: Center(
                              //                   child: Row(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.center,
                              //                     children: [
                              //                       ExerciseType.RepBased == ex.type ? Text(ex.reps.toString()) : Text(ex.duration.toString())
                              //                     ],
                              //                   ),
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              // ],
                              //   ),
                              // ),
                              // Container(
                              //   //padding: EdgeInsets.symmetric(horizontal: 10),
                              //   height: 200,
                              //   child: GridView.builder(
                              //     gridDelegate:
                              //         SliverGridDelegateWithFixedCrossAxisCount(
                              //       mainAxisSpacing: 5,
                              //       crossAxisCount: 1,
                              //     ),
                              //     scrollDirection: Axis.horizontal,
                              //     addRepaintBoundaries: true,
                              //     // itemCount: _exercise.length,
                              //     itemCount: 10,
                              //     itemBuilder: (context, index) => Card(
                              //       clipBehavior: Clip.antiAlias,
                              //       elevation: 5,
                              //       child: Center(
                              //         child: Column(
                              //           children: [
                              //             Flexible(
                              //               fit: FlexFit.tight,
                              //               flex: 1,
                              //               child: Stack(
                              //                 children: [
                              //                   Container(
                              //                     decoration: BoxDecoration(
                              //                       gradient: LinearGradient(
                              //                         colors: [
                              //                           Colors.orange[200],
                              //                           Colors.orange[700],
                              //                         ],
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   Center(
                              //                     child: Text("Exercise $index"),
                              //                   ),
                              //                 ],
                              //               ),
                              //             ),
                              //             Flexible(
                              //               fit: FlexFit.tight,
                              //               flex: 2,
                              //               child: Center(
                              //                 child: SingleChildScrollView(
                              //                   padding: EdgeInsets.all(10),
                              //                   child: Text(
                              //                     "$index This will be a description long  saasdfsdfasdfasdfadsfasdfsff saasdfsdfasdfasdfadsfasdfsffsaasdfsdfasdfasdfadsfasdfsffsaasdfsdfasdfasdfadsfasdfsffsaasdfsdfasdfasdfadsfasdfsffsaasdfsdfasdfasdfadsfasdfsffsaasdfsdfasdfasdfadsfasdfsff",
                              //                     textAlign: TextAlign.center,
                              //                     //maxLines: 4,
                              //                   ),
                              //                 ),
                              //               ),
                              //             ),
                              //             Flexible(
                              //               fit: FlexFit.tight,
                              //               flex: 1,
                              //               child: Center(
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.center,
                              //                   children: [
                              //                     index % 2 == 0
                              //                         ? Text(
                              //                             "1h30min",
                              //                           )
                              //                         : Text("30x"),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
