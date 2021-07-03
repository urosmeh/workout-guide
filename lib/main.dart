import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:workout_guide/providers/exercises.dart';
import 'package:workout_guide/providers/workouts.dart';
import 'package:workout_guide/screens/auth_screen.dart';
import 'package:workout_guide/screens/workout_exercises_screen.dart';
import 'package:workout_guide/screens/edit_workout_screen.dart';
import 'package:workout_guide/screens/workouts_screen.dart';

import 'providers/auth.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print(await FirebaseMessaging.instance.getToken());

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      RemoteNotification notification = msg.notification;
      AndroidNotification androidNotification = msg.notification?.android;
      if (androidNotification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.pink,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
    }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      RemoteNotification notification = msg.notification;
      AndroidNotification androidNotification = msg.notification?.android;
      if (notification != null && androidNotification != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(notification.title),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body),
                ],
              ),
            ),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Workouts>(
          create: (_) => Workouts(null, null, []),
          update: (ctx, auth, previousWorkouts) => Workouts(
            auth.token,
            auth.userId,
            previousWorkouts == null ? [] : previousWorkouts.workouts,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Exercises>(
          create: (_) => Exercises(null, null, []),
          update: (ctx, auth, previousExercises) => Exercises(
            auth.token,
            auth.userId,
            previousExercises == null ? [] : previousExercises.exercises,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, child) {
          return MaterialApp(
            title: "Workout guide",
            theme: ThemeData(
              primarySwatch: Colors.pink,
              accentColor: Colors.deepOrange,
            ),
            home: auth.isAuth
                ? WorkoutsScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authRes) =>
                        authRes.connectionState == ConnectionState.waiting
                            ? Scaffold(
                                body: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : AuthScreen(),
                  ),
            routes: {
              EditWorkoutScreen.route: (ctx) => EditWorkoutScreen(),
              WorkoutsScreen.route: (ctx) => WorkoutsScreen(),
              AuthScreen.route: (ctx) => AuthScreen(),
              WorkoutExercisesScreen.route: (ctx) => WorkoutExercisesScreen(),
            },
          );
        },
      ),
    );
  }
}
