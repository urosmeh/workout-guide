import 'package:flutter/material.dart';

class ExercisesListItem extends StatelessWidget {
  final workout;
  final id;
  final title;
  final description;
  final reps;
  final duration;
  final type;
  final key;

  ExercisesListItem({
    @required this.workout,
    @required this.id,
    @required this.title,
    this.description,
    this.reps,
    this.duration,
    this.type,
    @required this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: EdgeInsets.only(top: 20),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          workout.removeExercise(this.id);
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
        key: ValueKey(id),
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Are you sure?"),
              content: Text("Do you want to remove this exercise?"),
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
        child: Card(
          elevation: 5,
          child: ListTile(
            leading: Text(title),
          ),
        ),
      ),
    );
  }
}
