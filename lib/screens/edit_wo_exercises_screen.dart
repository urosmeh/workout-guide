import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/workouts.dart';

class EditWorkoutExercisesScreen extends StatefulWidget {
  static const route = "/edit-exercises";

  @override
  _EditWorkoutExercisesScreenState createState() =>
      _EditWorkoutExercisesScreenState();
}

class _EditWorkoutExercisesScreenState
    extends State<EditWorkoutExercisesScreen> {
  var workout;
  var workoutId;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      workoutId = ModalRoute.of(context).settings.arguments as String;

      if (workoutId != null) {
        workout = Provider.of<Workouts>(context, listen: false)
            .getWorkoutById(workoutId);
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${workout.title} exercises"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        Text("Add new"),
                      ],
                    ),
                    onPressed: () {
                      //TODO: form
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 100,
                              width: 100,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Text("test"),
                              ),
                            );
                          });
                    },
                  ),
                  TextButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add),
                        Text("Pick existing"),
                      ],
                    ),
                    onPressed: () {},
                  )
                ],
              ),
              Text("list of exercises on this workout"),
            ],
          ),
        ),
      ),
    );
  }
}
