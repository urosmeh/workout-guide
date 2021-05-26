import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/workout.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/widgets/add_workout_exercise_modal.dart';
import 'package:workout_guide/widgets/dropdown_container.dart';
import 'package:workout_guide/widgets/edit_exercise.dart';
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

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<Exercises>(context, listen: false);
    // exercises = await Provider.of<Exercises>(context, listen: false)
    //     .getExercisesByIds(workout.exerciseIds);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      workoutId = ModalRoute.of(context).settings.arguments as String;
      if (workoutId != null) {
        workout = Provider.of<Workouts>(context, listen: true)
            .getWorkoutById(workoutId);
        workout.addExercise("asdsad");
      }
    }
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
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, _, __) {
                return AddWorkoutExerciseModal(workoutId);
              },
              settings: RouteSettings(
                arguments: workoutId,
              ),
              fullscreenDialog: false,
              opaque: false,
              maintainState: true,
            ),
          );
        },
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshList(
                      context,
                    ),
                    child: Consumer<Exercises>(
                      builder: (ctx, exercisesData, child) {
                        exercises = exercisesData.exercises ?? [];
                        return CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              title: Text("Upcoming"),
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
                                        child: Text(
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
