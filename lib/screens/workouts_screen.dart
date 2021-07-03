import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';
import 'package:workout_guide/widgets/workouts_list.dart';

class WorkoutsScreen extends StatefulWidget {
  static const route = "/workouts";

  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}
class _WorkoutsScreenState extends State<WorkoutsScreen> {
  Future<void> _refreshList(BuildContext context) async {
    await Provider.of<Workouts>(context, listen: false).getAndSetWorkouts();
    await Provider.of<Exercises>(context, listen: false).getAndSetExercises();
  }

  var _showAll = false;

  @override
  Widget build(BuildContext context) {
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
                child: Consumer<Workouts>(
                  builder: (ctx, workoutsData, child) {
                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          actions: [
                            Row(
                              children: [
                                Text(
                                  "All",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: _showAll,
                                  onChanged: (val) {
                                    setState(() {
                                      _showAll = val;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                          title: Text(_showAll ? "All workouts" : "Upcoming"),
                          //centerTitle: true,
                          floating: true,
                        ),
                        if (workoutsData.workouts.length > 0 && _showAll)
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => WorkoutsList(
                                  id: workoutsData.workouts[index].id,
                                  title: workoutsData.workouts[index].title,
                                  datetime:
                                      workoutsData.workouts[index].dateTime,
                                  approxDurationString: workoutsData
                                      .workouts[index].approxDurationString,
                                  difficulty:
                                      workoutsData.workouts[index].difficulty,
                                  equipment:
                                      workoutsData.workouts[index].equipment,
                                  exerciseIds:
                                      workoutsData.workouts[index].exerciseIds,
                                  index: index,
                                  prevDate: index > 0
                                      ? workoutsData
                                          .workouts[index - 1].dateTime
                                      : null),
                              childCount: workoutsData.workouts.length,
                            ),
                          ),
                        if (workoutsData.upcomingWorkouts.length > 0 &&
                            !_showAll) //move on sliver list
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => WorkoutsList(
                                  id: workoutsData.upcomingWorkouts[index].id,
                                  title: workoutsData
                                      .upcomingWorkouts[index].title,
                                  datetime: workoutsData
                                      .upcomingWorkouts[index].dateTime,
                                  approxDurationString: workoutsData
                                      .upcomingWorkouts[index]
                                      .approxDurationString,
                                  difficulty: workoutsData
                                      .upcomingWorkouts[index].difficulty,
                                  equipment: workoutsData
                                      .upcomingWorkouts[index].equipment,
                                  exerciseIds: workoutsData
                                      .upcomingWorkouts[index].exerciseIds,
                                  index: index,
                                  prevDate: index > 0
                                      ? workoutsData
                                          .upcomingWorkouts[index - 1].dateTime
                                      : null),
                              childCount: workoutsData.upcomingWorkouts.length,
                            ),
                          ),
                        if (workoutsData.upcomingWorkouts.length == 0 &&
                            !_showAll)
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: Center(
                                    child: Text(
                                      "No upcoming workouts",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
      ),
    );
  }
}
