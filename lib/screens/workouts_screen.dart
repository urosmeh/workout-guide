import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/test_data.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';
import 'package:workout_guide/widgets/workouts_list.dart';

class WorkoutsScreen extends StatelessWidget {
  static const route = "/workouts";

  @override
  Widget build(BuildContext context) {
    // final appBar = AppBar(
    //   title: const Text("Upcoming"),
    //   centerTitle: true,
    // );
    final _workoutsData = Provider.of<Workouts>(context);
    final _workouts = _workoutsData.workouts;

    return Scaffold(
      //appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).pushNamed(EditWorkoutScreen.route),
      ),
      // body: Container(
      //   height: MediaQuery.of(context).size.height -
      //       appBar.preferredSize.height -
      //       MediaQuery.of(context).padding.top,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Upcoming"),
            centerTitle: true,
            floating: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => WorkoutsList(
                id: _workouts[index].id,
                title: _workouts[index].title,
                datetime: _workouts[index].dateTime,
                approxDurationString: _workouts[index].approxDurationString,
                difficulty: _workouts[index].difficulty,
                equipment: _workouts[index].equipment,
              ),
              childCount: _workouts.length,
            ),
          ),
          // ListView.builder(
          //   itemBuilder: (context, index) {
          //     return Card(
          //       elevation: 10,
          //       child: ListTile(
          //           title: Text(_workouts[index].title),
          //           leading: Icon(
          //             Icons.circle,
          //             color: difficultyColor(_workouts[index].difficulty),
          //           ),
          //           subtitle: Container(
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Text(_workouts[index].equipment),
          //                 Text(_workouts[index].dateTime.toString())
          //               ],
          //             ),
          //           ),
          //           trailing: IconButton(
          //               icon: Icon(Icons.play_arrow), onPressed: () {})),
          //     );
          //   },
          //   itemCount: _workouts.length,
          // ),
        ],
      ),
    );
  }
}
