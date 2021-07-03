import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/helpers.dart';
import 'package:workout_guide/widgets/duration_progress_indicator.dart';
import 'package:workout_guide/widgets/workout_finished.dart';

class WorkoutPlayerScreen extends StatefulWidget {
  //const WorkoutPlayerScreen({Key key}) : super(key: key);
  static const route = "/workout-player";
  final id;
  final title;
  final exercises;
  final duration;
  final equipment;
  final difficulty;

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
  Timer tDur;
  var paused = false;
  var skipped = 0;
  var tCount = 0;

  final GlobalKey<AnimatedListState> _key = GlobalKey();

  void _removeItem() {
    if (remaining.length == 0) {
      return;
    }
    Exercise removed = remaining.removeAt(0);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removed, animation, 0);
    };
    _key.currentState.removeItem(0, builder);
  }

  Widget _buildItem(Exercise item, Animation<double> animation, int index) {
    return SizeTransition(
      axis: Axis.horizontal,
      sizeFactor: animation,
      key: ValueKey("${index + 100}"),
      child: Card(
        key: ValueKey(index.toString()),
        elevation: 2,
        child: Container(
          width: 150,
          height: 150,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  remaining[index].title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(remaining[index].description),
              ),
              Expanded(
                child: Text(remaining[index].type == ExerciseType.TimeBased
                    ? Helpers.durationString(remaining[index].duration)
                    : remaining[index].reps.toString() + "x"),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
    if (tDur != null) {
      tDur.cancel();
    }
    super.dispose();
  }

  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.exercises[counter].type == ExerciseType.TimeBased)
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
                if (counter == 0) {
                  tDur = Timer.periodic(
                      const Duration(
                        seconds: 1,
                      ), (Timer tDur) {
                    tCount++;
                  });
                }
                animController
                    .forward(from: animController.value)
                    .then((value) async {
                  if (counter < widget.exercises.length - 1) {
                    setState(() {
                      counter++;
                      _removeItem();

                      //remaining.removeAt(0);
                    });

                    await animController.reverse(
                      from: animController.value,
                    );

                    if (widget.exercises[counter].type ==
                        ExerciseType.TimeBased) {
                      animController.duration =
                          widget.exercises[counter].duration;
                      animController.forward(from: 0.0);
                    }
                  } else {
                    setState(() {
                      tDur.cancel();
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
            if (widget.exercises[counter].type as ExerciseType !=
                ExerciseType.RepBased) {
              skipped++;
            }
            if (counter < widget.exercises.length - 1) {
              setState(() {
                counter++;
                //remaining.removeAt(0);
              });
              if (remaining.length > 1) {
                _removeItem();
              } else {
                remaining.removeAt(0);
              }

              await animController.reverse(
                from: animController.value,
              );

              if (widget.exercises[counter].type == ExerciseType.TimeBased) {
                animController.duration = widget.exercises[counter].duration;
                animController.forward(from: 0.0).then((value) async {
                  if (counter < widget.exercises.length - 1) {
                    setState(() {
                      counter++;
                      _removeItem();
                      //remaining.removeAt(0);
                    });

                    await animController.reverse(
                      from: animController.value,
                    );

                    if (widget.exercises[counter].type ==
                        ExerciseType.TimeBased) {
                      animController.duration =
                          widget.exercises[counter].duration;
                      animController.forward(from: 0.0);
                    }
                  } else {
                    setState(() {
                      tDur.cancel();
                      workoutFinished = true;
                    });
                  }
                });
              }
            } else {
              setState(() {
                tDur.cancel();
                workoutFinished = true;
              });
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: !workoutFinished
            ? Column(
                children: [
                  Container(
                    child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
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
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
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
                                                      barColor:
                                                          Theme.of(context)
                                                              .accentColor,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Align(
                                              alignment:
                                                  FractionalOffset.center,
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
                              widget.exercises[counter].description,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          buildButtonRow(),
                          AnimatedContainer(
                            curve: Curves.slowMiddle,
                            duration: const Duration(milliseconds: 500),
                            height: remaining.length > 0 ? 150 : 0,
                            width: double.infinity,
                            child: remaining.length > 0
                                ? AnimatedList(
                                    scrollDirection: Axis.horizontal,
                                    key: _key,
                                    initialItemCount: remaining.length,
                                    itemBuilder: (context, index, animation) =>
                                        _buildItem(
                                            remaining[index], animation, index),
                                  )
                                : Container(
                                    width: 150,
                                    height: 150,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : WorkoutFinished(
                widget.id,
                widget.exercises.length,
                skipped,
                Helpers.durationString(
                  Duration(seconds: tCount),
                ),
              ),
      ),
    );
  }
}
