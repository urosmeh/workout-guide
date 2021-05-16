import 'package:workout_guide/models/workout.dart';

import 'exercise.dart';

final workouts = [
  Workout(
    title: "Full body",
    exercises: [
      Exercise(
        id: "e1",
        title: "Run in place",
        type: ExerciseType.TimeBased,
        description: "Just run in place for time given",
        duration: Duration(
          seconds: 30,
        ),
      ),
      Exercise(
        id: "e2",
        title: "Jumping jacks",
        type: ExerciseType.TimeBased,
        description:
            "Jump with legs spread wide and hands overhead, then return in position with feet together and arms at sides",
        duration: Duration(
          minutes: 1,
        ),
      ),
      Exercise(
        id: "e3",
        title: "Squats",
        type: ExerciseType.RepBased,
        description:
            "Squat with flat back, knees always behind toes, to 90degrees",
        reps: 20,
      ),
      Exercise(
        id: "e4",
        title: "Lunges",
        type: ExerciseType.RepBased,
        description: "Jump with crossing lets front/back, same with arms",
        reps: 20,
      ),
      Exercise(
        id: "e5",
        title: "Burpees",
        type: ExerciseType.RepBased,
        description: "Squat, push-up, jump, repeat",
        reps: 20,
      ),
    ],
    dateTime: DateTime.now(),
    approxDuration: Duration(
      minutes: 10,
    ),
    workoutType: WorkoutType.Mixed,
    difficulty: Difficulty.Hard
  ),
    Workout(
    title: "Not full body",
    exercises: [
      Exercise(
        id: DateTime.now().toString(),
        title: "Run in place",
        type: ExerciseType.TimeBased,
        description: "Just run in place for time given",
        duration: Duration(
          seconds: 30,
        ),
      ),
      Exercise(
        id: DateTime.now().toString(),
        title: "Jumping jacks",
        type: ExerciseType.TimeBased,
        description:
            "Jump with legs spread wide and hands overhead, then return in position with feet together and arms at sides",
        duration: Duration(
          minutes: 1,
        ),
      ),
      Exercise(
        id: DateTime.now().toString(),
        title: "Squats",
        type: ExerciseType.RepBased,
        description:
            "Squat with flat back, knees always behind toes, to 90degrees",
        reps: 20,
      ),
      Exercise(
        id: DateTime.now().toString(),
        title: "Lunges",
        type: ExerciseType.RepBased,
        description: "Jump with crossing lets front/back, same with arms",
        reps: 20,
      ),
      Exercise(
        id: DateTime.now().toString(),
        title: "Burpees",
        type: ExerciseType.RepBased,
        description: "Squat, push-up, jump, repeat",
        reps: 20,
      ),
    ],
    dateTime: DateTime(2021, 5, 20, 13, 30),
    approxDuration: Duration(
      minutes: 70,
    ),
    workoutType: WorkoutType.Mixed,
    difficulty: Difficulty.Easy,
    equipment: "Dumbells, mat"
  )
];
