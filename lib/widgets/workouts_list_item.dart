import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  void openWorkoutModal(BuildContext context, String workoutId) {
    Workout w =
        Provider.of<Workouts>(context, listen: false).getWorkoutById(workoutId);

    if (w != null) {
      showModalBottomSheet(
        // backgroundColor: Colors.white,
        elevation: 10,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        context: context,
        builder: (_) {
          return Column(
            //mainAxisSize: MainAxisSize.min,
//             Workout({
//   this.id,
//   @required this.title,
//   this.exercises,
//   @required this.dateTime,
//   this.equipment = "No equipment needed",
//   this.approxDuration,
//   this.kcalBurned,
//   @required this.workoutType,
//   @required this.difficulty,
//   this.isFinished = false,
// });
            children: [
              Text(
                w.title,
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                DateFormat("EEEE - HH:mm").format(w.dateTime),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Difficulty",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "${w.difficultyString}",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Type",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "${w.workoutTypeString}",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Duration",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          "${w.approxDurationString}",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Equipment",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                w.equipment.length > 50
                                    ? w.equipment.substring(0, 50) + "..."
                                    : w.equipment,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Text("TODO: List of exercises"),
              )
            ],
          );
        },
      );
    }
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
          onLongPress: () => openWorkoutModal(context, id),
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () {},
              ),
              PopupMenuButton(
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
            ],
          ),
        ),
      ),
    );
  }
}
