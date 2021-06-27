import 'package:flutter/material.dart';
import 'package:workout_guide/models/exercise.dart';
import 'package:workout_guide/models/helpers.dart';

class RemainingList extends StatelessWidget {
  final remaining;

  RemainingList(this.remaining);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.slowMiddle,
      duration: const Duration(milliseconds: 500),
      height: remaining.length > 0 ? 150 : 0,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: remaining.length,
        itemBuilder: (_, index) => Container(
          width: 150,
          height: 150,
          child: Card(
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
      ),
    );
  }
}
