import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:workout_guide/models/helpers.dart';
import 'package:workout_guide/widgets/duration_progress_indicator.dart';

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
  var oneSec = Duration(seconds: 1);
  int counter = 0;
  int currentTime = -1;
  AnimationController animController;
  Timer currentTimeAdder;

  Timer t;

  String get timerString {
    print(animController.duration);
    print(animController.value);
    Duration duration = animController.duration -
        animController.duration * animController.value;
    return Helpers.durationString(duration);
  }

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      reverseDuration: Duration(seconds: 1),
      value: 0,
      duration: widget.exercises[counter].duration,
    );

    super.initState();
  }

  void addCurrTime() {
    currentTime =
        currentTime == animController.duration.inSeconds ? -1 : currentTime + 1;
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
          Container(
            //padding: EdgeInsets.all(10),
            child: Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    // leading: Icon(Icons.arrow_drop_down_circle),
                    title: Center(
                      child: Text(
                        widget.exercises[0].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      widget.exercises[0].description,
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
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
                                          painter: DurationProgressIndicator(
                                            animation: animController,
                                            backgroundColor: Colors.white,
                                            barColor:
                                                Theme.of(context).accentColor,
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
                              ),
                            ),
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
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          } else {
                            animController.forward(from: animController.value);
                          }
                          //setState(() {});
                        },
                      ),
                      IconButton(
                        color: Theme.of(context).accentColor,
                        iconSize: 50,
                        icon: Icon(Icons.next_plan_sharp),
                        onPressed: () async {
                          setState(() {});
                          counter ++;
                          await animController.reverse(
                            from: animController.value,
                          );

                          animController.duration =
                              widget.exercises[counter].duration;
                          animController.forward(from: 0.0);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
