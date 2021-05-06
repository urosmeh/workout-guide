import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/test_data.dart';
import 'package:workout_guide/providers/workout.dart';
import 'package:workout_guide/widgets/dropdown_container.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const route = "/edit-workout";

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  double _approxHours = 0;
  double _approxMins = 0;
  Duration _approxDuration; //convert approx hours and mins to duration onsave
  DateTime _date;
  Difficulty _difficulty;
  String _selDifficulty;
  WorkoutType _workoutType;
  String _selWorkoutType;
  List<Exercise> _exercise = [];

  final _form = GlobalKey<FormState>();

  // Map<String, dynamic> newWorkout = {
  //   "title": "",
  //   "approxDuration": null,
  //   "dateTime": null,
  //   "difficulty": null,
  //   //...
  // };

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

    void _saveForm() {
      setState(() {
        isLoading = true;
      });

      //check for errors

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
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
                          child: OutlinedButton(
                            onPressed: () => _presentDateAndTimePicker(context),
                            child: Text("Select date and time"),
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
                            onPressed: () => _saveForm(),
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
      ),
    );
  }
}
