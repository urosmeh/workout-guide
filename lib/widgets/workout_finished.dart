import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/widgets/summary_table.dart';

class WorkoutFinished extends StatefulWidget {
  @override
  _WorkoutFinishedState createState() => _WorkoutFinishedState();
  final _exercisesN;
  final _skippedN;
  final _dString;
  final _workoutId;

  WorkoutFinished(
      this._workoutId, this._exercisesN, this._skippedN, this._dString);
}

class _WorkoutFinishedState extends State<WorkoutFinished>
    with TickerProviderStateMixin {
  Timer _t;
  var _visible = false;
  final _form = GlobalKey<FormState>();
  var _kcal;
  var _isLoading = false;

  @override
  void initState() {
    _t = Timer(Duration(milliseconds: 200), () {
      setState(() {
        _visible = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_t != null) {
      _t.cancel();
    }
    super.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final isFormValid = _form.currentState.validate();

    if (isFormValid) {
      _form.currentState.save();
      var wo = Provider.of<Workouts>(context, listen: false)
          .getWorkoutById(widget._workoutId);
      wo.isFinished = true;
      wo.kcalBurned = int.parse(_kcal);
      final status = await Provider.of<Workouts>(context, listen: false)
          .updateWorkout(widget._workoutId, wo);
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
      _isLoading = false;
      Navigator.of(context).pop();
    } else {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: Duration(milliseconds: 500),
      child: !_isLoading
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Congratulations! You've finished your workout!",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            height: 140,
                            child: Card(
                              elevation: 5,
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Summary",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: SummaryTable(
                                        widget._exercisesN,
                                        widget._skippedN,
                                        widget._dString,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      child: Form(
                        key: _form,
                        child: Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (value) =>
                                    _kcal = value.isEmpty ? "0" : value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    value = "0";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: OutlineInputBorder(),
                                  labelText:
                                      "How many calories have you burnt ?",
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                alignment: AlignmentDirectional.center,
                                child: TextButton(
                                  onPressed: () => _saveForm(context),
                                  child: Text("Finish"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
