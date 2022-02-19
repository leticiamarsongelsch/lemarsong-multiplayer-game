import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'gameUI.dart';

Future<void> main() async {
  SharedPreferences storage = await SharedPreferences.getInstance();

  GameUI gameUI = GameUI();
  /*GameScreen gameScreen = GameScreen(gameUI);
  gameUI.state.storage = storage;
  gameUI.state.gameScreen = gameScreen;*/

  runApp(
    MaterialApp(
      title: "Teste",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: ()=> gameUI.pauseEngine(),
                  child: Text("Pause")
              ),
              TextButton(
                  onPressed: ()=> gameUI.resumeEngine(),
                  child: Text("Continue")
              ),
              Text(
                "Testando meu joguinho",
              ),
              Container(
                width: 500,
                height: 400,
                color: Colors.amber,
                child:
                Stack(
                  fit: StackFit.expand,
                  children: [
                    //GameWidget(game: gameUI),
                    /*Positioned.fill(
                        child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: ()=> gameUI.pauseEngine(),
                      onLongPress: ()=> gameUI.resumeEngine(),
                      child: GameWidget(game: gameUI),
                    )
                    ),*/
                    Positioned.fill(child: GameWidget(game: gameUI,)),
                  ],
                ),
              )
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    ),
  );
}
