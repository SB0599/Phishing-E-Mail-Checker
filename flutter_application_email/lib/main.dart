import 'dart:async';

import 'package:flutter/material.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/services.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'mail.dart';
import 'parse.dart';
//import 'Routine.dart';
import 'background_task.dart';
import 'notification.dart';
import 'widget/navigation_drawer.dart';
import 'start_background_task.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // config file
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// For MISP because need SSL Certificat
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static EMail mail = new EMail();
  static ParseMail parser = new ParseMailURL();
  static final storage = new FlutterSecureStorage();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Email Scanner',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Email Scanner'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // background working
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  // notification

  // Application
  int _counter = 0;
  final PasswordField = TextEditingController();
  final EmailField = TextEditingController();

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    //call in init state;

    notificationService = NotificationService();
    listenToNotificationStream();
    notificationService.initializePlatformNotifications();
    Workmanager().initialize(
        checkNewMail, // The top level function, aka callbackDispatcher
        isInDebugMode:
            true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    initAutoStart();
    startRoutine();
  }

  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((payload) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => _mySignUpPage()));
      });

  //initializing the autoStart with the first build.
  Future<void> initAutoStart() async {
    try {
      //   var status = await Permission.;
      // if (!status.isGranted) {
      //   Map<Permission, PermissionStatus> statuses = await [
      //     Permission.location,
      //     Permission.storage,
      //     Permission.manageExternalStorage,
      //   ].request();
      // }
      //check auto-start availability.
      var test = await (isAutoStartAvailable as Future<bool?>);
      print(test);
      //if available then navigate to auto-start setting page.
      if (test != null) {
        if (true)
          await getAutoStartPermission();
        else
          print("no autostart permisson");
        //visibleflag2 = true;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  void startRoutine() async {
    if ("true" == await MyApp.storage.read(key: "isSignIn")) {
      startTask();
      print("start task over registry credential");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _mySignUpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Hello"),
                ]),
          ),
        ));
  }
}

class _mySignUpPage extends StatelessWidget {
  void _signOut() {
    MyApp.mail.MailLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signed in"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Signed In"),
              TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blueGrey),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  //_signOut();
                  Navigator.pop(context);
                  Workmanager().cancelAll();
                  // TODO: credential aus registy löschen
                },
                child: Text('sign out'),
              )
            ]),
      ),
    );
  }
}
