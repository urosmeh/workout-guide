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
  var _pickedExercise;
  var _isLoading = false;

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<Exercises>(context, listen: false).getAndSetExercises();
    if (workout.exerciseIds != null || workout.exerciseIds.length >= 0) {
      exercises = Provider.of<Exercises>(context, listen: false)
          .getExercisesByIds(workout.exerciseIds);
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
        print(workout.exerciseIds);
        await Provider.of<Exercises>(context, listen: false)
            .getAndSetExercises();
        if (workout.exerciseIds != null || workout.exerciseIds.length >= 0) {
          exercises = Provider.of<Exercises>(context, listen: false)
              .getExercisesByIds(workout.exerciseIds) ?? [];
        }
      }
    }
    _isLoading = false;

    _isInit = false;
    super.didChangeDependencies();
  }

  void setPickedExercise(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _pickedExercise = value;
      });
    }
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
              print("sd: $workoutId");
              //.route, arguments: w.id);
              return AddWorkoutExerciseModal(workoutId);
            },
            barrierColor: Colors.transparent,
          );
        },
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting ?? _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshList(
                      context,
                    ),
                    child: Consumer<Exercises>(
                      builder: (ctx, exercisesData, child) {
                        //exercises = exercisesData.exercises ?? [];
                        return CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              title: Text("Exercises"),
                              centerTitle: true,
                              floating: true,
                            ),
                            if (exercises.length > 0)
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => ExercisesListItem(
                                    id: exercises[index].id,
                                    title: exercises[index].title,
                                    description: exercises[index].description,
                                    duration: exercises[index].duration,
                                    reps: exercises[index].reps,
                                    type: exercises[index].type,
                                  ),
                                  childCount: exercises.length,
                                ),
                              ),
                            if (exercises.length == 0)
                              SliverList(
                                delegate: SliverChildListDelegate(
                                  [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30),
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
                                    )
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
