import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_guide/models/helpers.dart';
import 'package:workout_guide/widgets/workouts_list_item.dart';

class WorkoutsList extends StatelessWidget {
  final id;
  final datetime;
  final title;
  final difficulty;
  final equipment;
  final approxDurationString;
  final exerciseIds;
  final index;
  final DateTime prevDate;

  WorkoutsList({
    @required this.id,
    @required this.title,
    @required this.datetime,
    @required this.difficulty,
    @required this.equipment,
    @required this.approxDurationString,
    @required this.exerciseIds,
    @required this.index,
    @required this.prevDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || Helpers.dayDifference(prevDate, datetime) != 0)
            Padding(
              padding: EdgeInsets.only(left: 10, top: index == 0 ? 10 : 30),
              child: Text(
                DateFormat("EEEE, d. MMMM y").format(datetime),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          WorkoutsListItem(
            id: id,
            title: title,
            approxDurationString: approxDurationString,
            dateTime: datetime,
            difficulty: difficulty,
            equipment: equipment,
            exerciseIds: exerciseIds,
          ),
        ],
      ),
    );
  }
}
