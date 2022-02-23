import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiplayer_game/login_screen.dart';
import 'package:multiplayer_game/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'authentication.dart';
import 'gameUI.dart';
/*
Future<void> main() async {

  runApp(
    MaterialApp(
      title: "Teste",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child:
            _authLogin(),
          ),
          //_theGameScreen(),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ),
  );

}*/
final Configurations configurations = Configurations();
Future<void> main() async {
  //runApp(MyApp());
  //Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: configurations.apiKey,
        authDomain: configurations.authDomain,
        projectId: configurations.projectId,
        storageBucket: configurations.storageBucket,
        messagingSenderId: configurations.messagingSenderId,
        appId: configurations.appId,
        measurementId: configurations.measurementId,
        databaseURL: configurations.databaseId,
    ),
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    builder: (context, _) => MyApp(),
  ),
  );
}

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
