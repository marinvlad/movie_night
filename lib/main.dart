import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_night/providers/archive_provider.dart';
import 'package:movie_night/providers/event_provider.dart';
import 'package:movie_night/providers/movie_provider.dart';
import 'package:movie_night/providers/source_provider.dart';
import 'package:movie_night/providers/user_provider.dart';
import 'package:movie_night/utils/commons.dart';
import 'package:movie_night/view/init/initializeProviderDataScreen.dart';
import 'package:movie_night/view/screens/register_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    run();
  });
}

void run() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  void initState() {
    Firebase.initializeApp();
    
    super.initState();
  }

  _showDialog(context, message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showDialog(context, message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _showDialog(context, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _showDialog(context, message);
      },
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MovieEventProvider()),
          Provider(create: (context) => MovieListProvider()),
          ChangeNotifierProvider(create: (context) => FirestoreProvider()),
          Provider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => SourceProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Api Calls like a Legend with Provider',
            theme: chuckyTheme,
            home: SplashScreen()));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

final chuckyTheme = ThemeData(
  primaryColor: Commons.backGroundColor,
  accentIconTheme: IconThemeData(color: Colors.black),
  fontFamily: 'Roboto',
  hintColor: Commons.backGroundColor
);

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  Future checkLoginStatus() async {
    final storage = FlutterSecureStorage();
    String loggedIn = await storage.read(key: "loginstatus");
    if (loggedIn == null || loggedIn == "loggedout") {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => RegisterPage()));
    } else {
      if (loggedIn == "loggedin") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    InitializeProviderDataScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
          child: Container(
        width: 250,
        child: Text(
          "MovieNight",
          style: TextStyle(
            color: Commons.backGroundColor,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
