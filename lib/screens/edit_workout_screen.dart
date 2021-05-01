import 'package:flutter/material.dart';
import 'package:workout_guide/providers/workout.dart';

class EditWorkoutScreen extends StatefulWidget {
  static const route = "/edit-workout";

  @override
  _EditWorkoutScreenState createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  double _approxHours = 0;
  double _approxMins = 0;
  Duration _approxDuration; //convert approx hours and mins to duration onsave
  DateTime _date;
  Difficulty _difficulty;
  String _selDifficulty;

  Map<String, dynamic> newWorkout = {
    "title": "",
    "approxDuration": null,
    "dateTime": null,
    "difficulty": null,
    //...
  };

  void _presentDateAndTimePicker(BuildContext context) async {
    final dt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (dt != null) {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (t != null) {
        setState(() {
          _date = DateTime(dt.year, dt.month, dt.day, t.hour, t.minute);
        });
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    const List<String> difficultyList = [
      "Easy",
      "Medium",
      "Hard",
    ];

    void setDifficulty(String value) {
      if (value.isNotEmpty) {
        setState(() {
          _selDifficulty = value;

          if (value == "Easy") {
            _difficulty = Difficulty.Easy;
          } else if (value == "Medium") {
            _difficulty = Difficulty.Medium;
          } else {
            _difficulty = Difficulty.Hard;
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    labelText: "Title",
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _presentDateAndTimePicker(context),
                            child: Text("Select date and time"),
                          ),
                        ),
                        Divider(),
                        Text("Approximate duration"),
                        Text(
                          "${_approxHours.toInt()}h ${_approxMins.toInt() * 15}min",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("hours"),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Slider(
                                  activeColor: _approxHours < 2
                                      ? Colors.green
                                      : _approxHours == 2
                                          ? Colors.orange
                                          : Colors.red,
                                  label: "${_approxHours.toInt()}",
                                  value: _approxHours,
                                  divisions: 3,
                                  min: 0,
                                  max: 3,
                                  onChanged: (val) {
                                    setState(() {
                                      _approxHours = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("mins"),
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Slider(
                                  label: "${(_approxMins * 15).toInt()}",
                                  value: _approxMins,
                                  divisions: 3,
                                  min: 0,
                                  max: 3,
                                  onChanged: (val) {
                                    setState(() {
                                      _approxMins = val;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Text("Difficulty"),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: DropdownButton(
                            underline: SizedBox(),
                            value: _selDifficulty,
                            onChanged: (value) {
                              print(value);
                              setDifficulty(value);
                            },
                            icon: Icon(Icons.arrow_drop_down_sharp),
                            elevation: 3,
                            isExpanded: true,
                            hint: Text("Difficulty"),
                            items: difficultyList
                                .map(
                                  (item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
