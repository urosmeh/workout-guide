import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/models/test_data.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';
import 'package:workout_guide/widgets/workouts_list.dart';

class WorkoutsScreen extends StatelessWidget {
  static const route = "/workouts";

  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<Workouts>(context, listen: false).getAndSetWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    // final appBar = AppBar(
    //   title: const Text("Upcoming"),
    //   centerTitle: true,
    // );

    return Scaffold(
      //appBar: workouts.length == 0 ? appBar : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            Navigator.of(context).pushNamed(EditWorkoutScreen.route),
      ),
      body: FutureBuilder(
        future: _refreshList(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshList(context),
                child: Consumer<Workouts>(builder: (ctx, workoutsData, child) {
                  if (workoutsData.workouts.length > 0) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          title: Text("Upcoming"),
                          centerTitle: true,
                          floating: true,
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => WorkoutsList(
                              id: workoutsData.workouts[index].id,
                              title: workoutsData.workouts[index].title,
                              datetime: workoutsData.workouts[index].dateTime,
                              approxDurationString: workoutsData
                                  .workouts[index].approxDurationString,
                              difficulty:
                                  workoutsData.workouts[index].difficulty,
                              equipment: workoutsData.workouts[index].equipment,
                            ),
                            childCount: workoutsData.workouts.length,
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
                    );
                  } else {
                    return Center(
                      child: Text("No upcoming workouts"),
                    );
                  }
                }),
              ),
      ),
    );
  }
}
