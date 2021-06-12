import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/workout.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/widgets/add_workout_exercise_modal.dart';
import 'package:workout_guide/widgets/exercises_list_item.dart';

class WorkoutExercisesScreen extends StatefulWidget {
  static const route = "/edit-exercises";

  @override
  _WorkoutExercisesScreenState createState() => _WorkoutExercisesScreenState();
}

class _WorkoutExercisesScreenState extends State<WorkoutExercisesScreen> {
  Workout workout;
  var workoutId;
  List<Exercise> exercises = [];
  var _isInit = true;
  var _isLoading = false;

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<Exercises>(context, listen: false).getAndSetExercises();
    if (workout.exerciseIds != null && workout.exerciseIds.length >= 0) {
      exercises = Provider.of<Exercises>(context, listen: false)
              .getExercisesByIds(workout.exerciseIds) ??
          [];
    }
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;
      workoutId = ModalRoute.of(context).settings.arguments as String;
      if (workoutId != null) {
        workout = Provider.of<Workouts>(context, listen: false)
            .getWorkoutById(workoutId);
        //print(workout.exerciseIds);
        await Provider.of<Exercises>(context, listen: false)
            .getAndSetExercises();
        if (workout.exerciseIds != null && workout.exerciseIds.length >= 0) {
          exercises = Provider.of<Exercises>(context, listen: false)
                  .getExercisesByIds(workout.exerciseIds) ??
              [];
        }
      }
    }
    _isLoading = false;

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext ctx) {
              return AddWorkoutExerciseModal(workoutId);
            },
            barrierColor: Colors.transparent,
          );
        },
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshList(
                  context,
                ),
                child: Consumer<Exercises>(
                  //child: Text("asd"),
                  builder: (ctx, exercisesData, child) {
                    print("ex builder m");
                    if (workout.exerciseIds != null &&
                        workout.exerciseIds.length > 0) {
                      //print(workout.exerciseIds);
                      exercises = exercisesData
                              .getExercisesByIds(workout.exerciseIds) ??
                          [];
                    }
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: Text("Exercises"),
                          centerTitle: true,
                          floating: true,
                          actions: [
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () async {
                                var status = await Provider.of<Workouts>(
                                  context,
                                  listen: false,
                                ).patchWOExercises(
                                  workout.id,
                                  workout.exerciseIds,
                                );

                                setState(() {
                                  _isLoading = true;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("Saving"),
                                          Container(
                                            height: 10,
                                            width: 10,
                                          ),
                                          Container(
                                            height: 10,
                                            width: 10,
                                            child: CircularProgressIndicator(strokeWidth: 2,),
                                          )
                                        ],
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    elevation: 10,
                                  ),
                                );

                                setState(() {
                                  _isLoading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          status
                                              ? Icon(Icons.check,
                                                  color: Colors.green)
                                              : Icon(Icons.close,
                                                  color: Colors.red),
                                          Text(status ? "Success" : "Error"),
                                        ],
                                      ),
                                    ),
                                    duration: Duration(seconds: 2),
                                    elevation: 10,
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        SliverReorderableList(
                          itemBuilder: (ctx, index) {
                            return ReorderableDragStartListener(
                              key: ValueKey(exercises[index].id +
                                  exercises[index].title +
                                  index.toString()),
                              index: index,
                              child: ExercisesListItem(
                                key: ValueKey(exercises[index].id +
                                    exercises[index].title),
                                workout: workout,
                                id: exercises[index].id,
                                title: exercises[index].title,
                                description: exercises[index].description,
                                duration: exercises[index].duration,
                                reps: exercises[index].reps,
                                type: exercises[index].type,
                              ),
                            );
                          },
                          itemCount: exercises.length,
                          onReorder: (oldIndex, newIndex) async {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            setState(() {
                              var tmp = workout.exerciseIds[oldIndex];
                              workout.exerciseIds.removeAt(oldIndex);
                              workout.exerciseIds.insert(newIndex, tmp);
                            });
                          },
                        ),
                        if (exercises.length == 0)
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 20, 5, 0),
                                  child: Center(
                                    child: _isLoading
                                        ? CircularProgressIndicator()
                                        : Text(
                                            "This workout has no exercises. Try adding some!",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
