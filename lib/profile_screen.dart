import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayer_game/user.dart';
import 'package:provider/provider.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

import 'authentication.dart';
import 'game_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  //DatabaseReference database = FirebaseDatabase.instance.reference().child("https://multiplayergame-9c158-default-rtdb.firebaseio.com/");

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 560;
    /*UserLoggedIn userloggedin= UserLoggedIn();
    if(userloggedin.userFirstTimeRegister=="true"){
    final AddDataDB = database.child("/Users/"+ UserLoggedIn().userId + "/");
      AddDataDB.set({
        'nameStudent': UserLoggedIn().userName,
        'email': UserLoggedIn().userEmail,
        'group': UserLoggedIn().userGroup,
        'teamColor': UserLoggedIn().userTeamColor,
      }).catchError((error)=> print("$error"));
    }*/

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: useMobileLayout? shortestSide:400,
              color: Colors.white,
              child:
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if(useMobileLayout)
                      _leftSideScreen(context),
                    Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                                        (Set<MaterialState> states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5);
                                      }
                                      return Colors.lightBlue; //Theme.of(context).colorScheme.onSecondary.withOpacity(0.5);
                                    }),
                              ),
                              onPressed: (){
                              _openGameScreen(context);
                              },
                              //-----------------------ABRIR O JOGO!
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "START GAME",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.white), //color
                                ),
                              ),
                            ))
                    ),
                    Padding(padding: EdgeInsets.all(20),
                      child:
                      Text(
                        "© 2022 Letícia Marson Gelschleiter. All rights reserved.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 10, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(!useMobileLayout)
                      _leftSideScreen(context),
          ],
        ),
      ),
    );
  }

  _leftSideScreen(BuildContext context){
    /*final RdbUserRef = database.child("/Users/");

    //quando o switch mudar
    if(UserLoggedIn().userFirstTimeRegister=="false"){
      RdbUserRef.child("/" + UserLoggedIn().userId + "/").update({
        'teamColor': UserLoggedIn().userTeamColor,
      });
    }*/

    return
      Expanded(
        child:
        Container(
          color: Colors.blue,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Padding(padding: EdgeInsets.all(20),
                child:
                Text(
                  "THIS IS YOUR PROFILE, MY HIGHNESS",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Padding(padding: EdgeInsets.all(20),
                child:
                Text(
                  "Choose your preferences, like... the team that you belong to,"
                      " your group... and I guess that that's all you can change.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith( color: Colors.white),
                ),
              ),
              Spacer(flex: 1),
              /*FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: ,
                ),*/
              Padding(padding: EdgeInsets.all(20),
                child:
                Text(
                  "If and just if for God's sake you didn't write your real name in your registration, "
                      "first of all get in contact with the system administrator, and second of all"
                      " why???? I warned you!!... gosh..",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  _openGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(),
      ),
    );
  }
}
