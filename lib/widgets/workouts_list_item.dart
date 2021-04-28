import 'package:flutter/material.dart';
import 'package:workout_guide/providers/workout.dart';

enum ItemOptions { Start, Edit }

class WorkoutsListItem extends StatelessWidget {
  final title;
  final equipment;
  final approxDurationString;
  final difficulty;

  WorkoutsListItem({
    this.title,
    this.equipment,
    this.approxDurationString,
    this.difficulty,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        title: Text(title),
        leading: Icon(
          Icons.circle,
          color: difficultyColor(difficulty),
        ),
        subtitle: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(equipment), Text(approxDurationString)],
          ),
        ),
        trailing: PopupMenuButton(
          child: Icon(Icons.more_vert),
          itemBuilder: (_) => [
            PopupMenuItem(
              child: Text("Edit"),
              value: ItemOptions.Edit,
            ),
            PopupMenuItem(
              child: Text("Start"),
              value: ItemOptions.Start,
            ),
          ],
          onSelected: (ItemOptions selected) {
            //open edit/start screen
          },
        ),
      ),
    );
  }
}
