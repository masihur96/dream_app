import 'package:dream_app/controller/theme_controller.dart';
import 'package:dream_app/firebase_options.dart';
import 'package:dream_app/pages/splash_screen_page.dart';
import 'package:dream_app/variables/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  try {


    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://bxfljtvmlhqjhkhnwtcv.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ4ZmxqdHZtbGhxamhraG53dGN2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEwNDQ4NjYsImV4cCI6MjA1NjYyMDg2Nn0.JLpuV9yKAlgFWmYdDb0DFs8_77Ng_reAMJ5p8yQ1Gdo',
    );

    requestNotificationPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.notification?.title}');
      print('Message data: ${message.notification?.body}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  } catch (e) {}
  // DevicePreview(
  //
  //    enabled: !kReleaseMode,
  //   builder: (context) => MyApp(), // Wrap your app
  // );
  runApp(MyApp());
}

Future<void> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Notification permission granted: ${settings.authorizationStatus}');
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.put(ThemeController());

    return GetBuilder(
      init: _themeController,
      builder: (_) {
        return GetMaterialApp(
          // locale: DevicePreview.locale(context), // Add the locale here
          // builder: DevicePreview.appBuilder, // Ad
          debugShowCheckedModeBanner: false,
          title: 'Mak B',
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode: ThemeMode.system,
          home: SplashScreen(),
        );
      },
    );
  }
}
