import 'package:flutter/material.dart';
import 'package:workout_guide/widgets/edit_exercise.dart';

class AddWorkoutExerciseModal extends StatelessWidget {
  static const route = "add-workout-exercise";
  final workoutId;
  AddWorkoutExerciseModal(this.workoutId);
  //AddWorkoutExerciseModal();

  Widget build(BuildContext context) {
    print("add_workout_exercise_modal $workoutId");
    //final workoutId = ModalRoute.of(context).settings.arguments as String;
    //print("workoutId from args: $workoutId");
    final mqObj = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(.4),
        body: Stack(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              splashColor: Colors.transparent,
              child: Ink(
                color: Colors.transparent,
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red,
                          elevation: 10,
                          shape: CircleBorder(),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.loose,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        width: mqObj.width * .95,
                        child: Card(
                          elevation: 10,
                          child: SingleChildScrollView(
                            child: EditExercise(workoutId),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
