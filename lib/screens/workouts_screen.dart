import 'package:flutter/material.dart';
import 'package:workout_guide/models/test_data.dart';
import 'package:workout_guide/providers/workout.dart';

class WorkoutsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text("Workouts"));
    final _workouts = workouts;

    MaterialColor difficultyColor(Difficulty difficulty) {
      print("getDiff");
      if (difficulty == Difficulty.Easy) {
        return Colors.green;
      } else if (difficulty == Difficulty.Medium) {
        return Colors.orange;
      } else if (difficulty == Difficulty.Hard) {
        return Colors.red;
      }
      return Colors.grey;
    }

    return Scaffold(
      appBar: appBar,
      body: Container(
        height: MediaQuery.of(context).size.height -
            appBar.preferredSize.height -
            MediaQuery.of(context).padding.top,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              elevation: 10,
              child: ListTile(
                  title: Text(_workouts[index].title),
                  leading: Icon(
                    Icons.circle,
                    color: difficultyColor(_workouts[index].difficulty),
                  ),
                  subtitle: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_workouts[index].equipment),
                        Text(_workouts[index].dateTime.toString())
                      ],
                    ),
                  ),
                  trailing: IconButton(
                      icon: Icon(Icons.play_arrow), onPressed: () {})),
            );
          },
          itemCount: _workouts.length,
        ),
      ),
    );
  }
}
