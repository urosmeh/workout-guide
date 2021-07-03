import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';

import 'dropdown_container.dart';

class EditExercise extends StatefulWidget {
  final workoutId;
  EditExercise(this.workoutId);

  @override
  _EditExerciseState createState() => _EditExerciseState();
}

class _EditExerciseState extends State<EditExercise> {
  String _title;
  String _description;
  int _hours = 0;
  int _mins = 0;
  int _seconds = 0;

  Duration _duration = Duration(
    hours: 0,
    minutes: 0,
    seconds: 0,
  );
  int reps = 0;

  ExerciseType _et;
  String _selET;

  final _form = GlobalKey<FormState>();
  bool isLoading = false;
  bool isTimeBased;
  String workoutId;

  @override
  Widget build(BuildContext context) {
    //Workout workout = Provider.of<Workouts>(context, listen: false).getWorkoutById(widget.workoutId);
    const List<String> exerciseTypes = [
      "Time",
      "Reps",
    ];

    void setExerciseType(String value) {
      if (value.isNotEmpty) {
        setState(() {
          _selET = value;
          if (value == "Time") {
            _et = ExerciseType.TimeBased;
          } else {
            _et = ExerciseType.RepBased;
          }
        });
      }
    }

    Future<void> _saveForm(BuildContext context) async {
      setState(() {
        isLoading = true;
      });

      final isFormValid = _form.currentState.validate();
      if (isFormValid) {
        _form.currentState.save();

        _duration = Duration(
          hours: _hours,
          minutes: _mins,
          seconds: _seconds,
        );

        Exercise ex = Exercise(
          title: _title,
          type: _et,
          description: _description,
          duration: _duration,
          reps: reps,
        );

        final exerciseId = await Provider.of<Exercises>(context, listen: false)
            .addExercise(ex);

        bool status = true;
        if (exerciseId != null) {
          status = await Provider.of<Workouts>(context, listen: false)
              .addExerciseToWorkout(widget.workoutId, exerciseId);
        }

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
        setState(() {
          isLoading = false;
        });
      }
    }

    return SingleChildScrollView(
      child: Form(
        key: _form,
        child: Container(
          padding: EdgeInsets.all(10),
          child: !isLoading
              ? Column(
                  children: [
                    TextFormField(
                      onSaved: (value) => _title = value,
                      autovalidateMode: AutovalidateMode.always,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text("Exercise Type"),
                            ),
                            DropdownContainer(
                              hint: "Exercise Type",
                              items: exerciseTypes,
                              value: _selET,
                              onDropdownSelect: setExerciseType,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.pink.shade100,
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: _selET == "Reps"
                                  ? TextFormField(
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(10),
                                        border: OutlineInputBorder(),
                                        labelText: "# of reps",
                                      ),
                                      validator: (value) {
                                        if (int.tryParse(value) == null) {
                                          return "Please enter a number";
                                        }
                                        if (value.isEmpty) {
                                          return "Please enter a number";
                                        }
                                        if (int.parse(value) <= 0.0) {
                                          return "Please enter valid number";
                                        }
                                        return null; //input is correct
                                      },
                                      onSaved: (value) {
                                        reps = int.parse(value);
                                      },
                                      keyboardType: TextInputType.number,
                                      autocorrect: false,
                                      textInputAction: TextInputAction.next,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onFieldSubmitted: (value) {},
                                    )
                                  : Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            flex: 5,
                                            child: TextFormField(
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: OutlineInputBorder(),
                                                labelText: "h",
                                              ),
                                              validator: (value) {
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return "0 - 3";
                                                }
                                                if (value.isEmpty) {
                                                  return "0 - 3";
                                                }
                                                if (int.parse(value) < 0.0) {
                                                  return "0 - 3";
                                                }
                                                if (int.parse(value) > 4) {
                                                  return "0 - 3";
                                                }
                                                return null; //input is correct
                                              },
                                              onSaved: (value) =>
                                                  _hours = int.tryParse(value),
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              textInputAction:
                                                  TextInputAction.next,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              onFieldSubmitted: (value) {},
                                            ),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            flex: 5,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: OutlineInputBorder(),
                                                labelText: "m",
                                              ),
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              validator: (value) {
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return "0-59";
                                                }
                                                if (value.isEmpty) {
                                                  return "0-59";
                                                }
                                                if (int.parse(value) < 0 ||
                                                    int.parse(value) >= 60) {
                                                  return "0-59";
                                                }
                                                return null; //input is correct
                                              },
                                              onSaved: (value) =>
                                                  _mins = int.parse(value),
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              textInputAction:
                                                  TextInputAction.next,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                            ),
                                          ),
                                          Spacer(
                                            flex: 1,
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            flex: 5,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                border: OutlineInputBorder(),
                                                labelText: "s",
                                              ),
                                              autovalidateMode:
                                                  AutovalidateMode.always,
                                              validator: (value) {
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return "0-59";
                                                }
                                                if (value.isEmpty) {
                                                  return "0-59";
                                                }
                                                if (int.parse(value) < 0 ||
                                                    int.parse(value) >= 60) {
                                                  return "0-59";
                                                }
                                                return null; //input is correct
                                              },
                                              onSaved: (value) =>
                                                  _seconds = int.parse(value),
                                              keyboardType:
                                                  TextInputType.number,
                                              autocorrect: false,
                                              textInputAction:
                                                  TextInputAction.next,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                            ),
                                          ),
                                          Spacer(flex: 1),
                                        ],
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                onSaved: (value) {
                                  _description = value;
                                },
                                keyboardType: TextInputType.multiline,
                                autocorrect: false,
                                maxLines: 2,
                                decoration: InputDecoration(
                                    labelText: "Description",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              alignment: AlignmentDirectional.centerEnd,
                              child: TextButton(
                                onPressed: () async {
                                  await _saveForm(context);
                                  Navigator.of(context).pop();
                                },
                                child: Text("Save"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
