import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/workout.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';

enum ItemOptions { Start, Edit }

class WorkoutsListItem extends StatelessWidget {
  final id;
  final title;
  final equipment;
  final approxDurationString;
  final difficulty;

  WorkoutsListItem({
    this.id,
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
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Workouts>(context, listen: false).removeWorkout(id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        margin: EdgeInsets.symmetric(
          horizontal: 3,
          vertical: 3,
        ),
        child: Container(
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to remove this workout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text("No"),
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: () => Navigator.of(context)
              .pushNamed(EditWorkoutScreen.route, arguments: id),
          title: Text(title),
          leading: Icon(
            Icons.circle,
            color: difficultyColor(difficulty),
          ),
          subtitle: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(equipment),
                Text(approxDurationString),
              ],
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
      ),
    );
  }
}
