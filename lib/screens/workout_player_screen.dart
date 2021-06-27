import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/helpers.dart';
import 'package:workout_guide/widgets/duration_progress_indicator.dart';
import 'package:workout_guide/widgets/remaining_exercises_widget.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  //const WorkoutPlayerScreen({Key key}) : super(key: key);
  static const route = "/workout-player";
  final id;
  final title;
  final exercises;
  final duration;
  final equipment;
  final difficulty;
  var remaining;

  WorkoutPlayerScreen({
    @required this.id,
    @required this.title,
    @required this.exercises,
    @required this.duration,
    @required this.equipment,
    @required this.difficulty,
  });

  @override
  _WorkoutPlayerScreenState createState() => _WorkoutPlayerScreenState();
}

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen>
    with TickerProviderStateMixin {
  int counter = 0;
  AnimationController animController;
  var workoutFinished = false;
  List<Exercise> remaining = [];
  Timer t;
  var paused = false;

  String get timerString {
    if (widget.exercises[counter].type == ExerciseType.TimeBased) {
      //widget.exercises[counter].type.toString());
      Duration duration = animController.duration -
          animController.duration * animController.value;
      return Helpers.durationString(duration);
    } else
      return "${widget.exercises[counter].reps}x";
  }

  @override
  void initState() {
    for (var i = 1; i < widget.exercises.length; i++) {
      remaining.add(widget.exercises[i]);
    }

    animController = AnimationController(
      vsync: this,
      reverseDuration: Duration(seconds: 1),
      value: 0,
      duration: widget.exercises[counter].duration,
    );

    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [],
      ),
      body: Column(
        children: [
          !workoutFinished
              ? Container(
                  child: Card(
                    elevation: 5,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title: Center(
                            child: Text(
                              widget.exercises[counter].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            widget.exercises[counter].description,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 150,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: FractionalOffset.center,
                                  child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: AnimatedBuilder(
                                              animation: animController,
                                              builder: (
                                                BuildContext context,
                                                Widget child,
                                              ) {
                                                return CustomPaint(
                                                  painter:
                                                      DurationProgressIndicator(
                                                    animation: animController,
                                                    backgroundColor:
                                                        Colors.white,
                                                    barColor: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Align(
                                            alignment: FractionalOffset.center,
                                            child: Container(
                                              child: AnimatedBuilder(
                                                animation: animController,
                                                builder: (
                                                  BuildContext context,
                                                  Widget child,
                                                ) {
                                                  return Text(
                                                    timerString,
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.exercises[counter].duration.toString() +
                                widget.exercises[counter].id,
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.exercises[counter].type ==
                                ExerciseType.TimeBased)
                              IconButton(
                                color: Theme.of(context).accentColor,
                                iconSize: 50,
                                icon: Icon(
                                  animController.isAnimating
                                      ? Icons.pause_circle_filled
                                      : Icons.play_circle_fill,
                                ),
                                onPressed: () {
                                  setState(() {});
                                  if (animController.isAnimating) {
                                    animController.stop();
                                    paused = true;
                                  } else {
                                    animController
                                        .forward(from: animController.value)
                                        .then((value) async {
                                      if (counter <
                                          widget.exercises.length - 1) {
                                        setState(() {
                                          counter++;
                                          remaining.removeAt(0);
                                        });

                                        await animController.reverse(
                                          from: animController.value,
                                        );

                                        if (widget.exercises[counter].type ==
                                            ExerciseType.TimeBased) {
                                          animController.duration = widget
                                              .exercises[counter].duration;
                                          animController.forward(from: 0.0);
                                        }
                                      } else {
                                        setState(() {
                                          print("workout finished");
                                          workoutFinished = true;
                                        });
                                      }
                                    });
                                  }
                                  //setState(() {});
                                },
                              ),
                            IconButton(
                              color: Theme.of(context).accentColor,
                              iconSize: 50,
                              icon: Icon(Icons.next_plan_sharp),
                              onPressed: () async {
                                // 0 => 1
                                if (counter < widget.exercises.length - 1) {
                                  setState(() {
                                    counter++;
                                    remaining.removeAt(0);
                                  });

                                  await animController.reverse(
                                    from: animController.value,
                                  );

                                  if (widget.exercises[counter].type ==
                                      ExerciseType.TimeBased) {
                                    animController.duration =
                                        widget.exercises[counter].duration;
                                    animController
                                        .forward(from: 0.0)
                                        .then((value) async {
                                      if (counter <
                                          widget.exercises.length - 1) {
                                        setState(() {
                                          counter++;
                                          remaining.removeAt(0);
                                        });

                                        await animController.reverse(
                                          from: animController.value,
                                        );

                                        if (widget.exercises[counter].type ==
                                            ExerciseType.TimeBased) {
                                          animController.duration = widget
                                              .exercises[counter].duration;
                                          animController.forward(from: 0.0);
                                        }
                                      } else {
                                        setState(() {
                                          print("workout finished");
                                          workoutFinished = true;
                                        });
                                      }
                                    });
                                  }
                                } else {
                                  setState(() {
                                    workoutFinished = true;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        RemainingList(remaining),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text("Finished"),
                ),
        ],
      ),
    );
  }
}
