import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_guide/widgets/workouts_list_item.dart';


class WorkoutsList extends StatelessWidget {
  final datetime;
  final title;
  final difficulty;
  final equipment;
  final approxDurationString;

  WorkoutsList({
    @required this.title,
    @required this.datetime,
    @required this.difficulty,
    @required this.equipment,
    @required this.approxDurationString,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              DateFormat("EEEE - HH:mm").format(datetime),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          WorkoutsListItem(
            title: title,
            approxDurationString: approxDurationString,
            difficulty: difficulty,
            equipment: equipment,
          ),
        ],
      ),
    );
  }
}
