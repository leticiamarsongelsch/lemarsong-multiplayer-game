import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplayer_game/gameUI.dart';
import 'package:multiplayer_game/main.dart';
import 'package:multiplayer_game/user.dart';
import 'package:provider/provider.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

import 'authentication.dart';
import 'components_list_matches.dart';
import 'game_screen.dart';
import 'matches.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>{
  FirebaseDatabase database = FirebaseDatabase.instance;
  late StreamSubscription _streamSubscription;
  bool value=false;


  @override
  void initState(){
    super.initState();
    _getGroup();
  }

  @override
  void deactivate(){
    _streamSubscription.cancel();
    super.deactivate();
  }

  void _getGroup(){
    DatabaseReference ref = database.reference();
    UserLoggedIn userloggedin= UserLoggedIn();
    _streamSubscription= ref.child("/Users/"+ UserLoggedIn().userId + "/teamColor").onValue.listen((event) {
      final String groupColor = event.snapshot.value;
      setState(() {
        userloggedin.userTeamColor = groupColor;
        if(groupColor=="green")value=false;
        else value=true;
        //print("AAAA:"+groupColor);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 560;

    DatabaseReference ref = database.reference();
    UserLoggedIn userloggedin= UserLoggedIn();
    if(userloggedin.userFirstTimeRegister=="true"){
      ref.child("/Users/"+ UserLoggedIn().userId + "/").set({
        'nameStudent': UserLoggedIn().userName,
        'email': UserLoggedIn().userEmail,
        'group': UserLoggedIn().userGroup,
        'teamColor': UserLoggedIn().userTeamColor,
      }).catchError((error)=> print("$error"));
    }

    final RdbUserMatchesRef = database.reference().child("/Users/"+UserLoggedIn().userId+"/Match/");

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
                    Padding(padding: EdgeInsets.all(20),
                      child:
                      Text(
                        UserLoggedIn().userName+", here are all the matches that you've played",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                          child: StreamBuilder(
                            stream: RdbUserMatchesRef.orderByKey().onValue,
                            builder: (context, snapshot) {
                              final listListMatches = <UserMatches>[];
                              if (snapshot.hasData) {
                                try {
                                  final MyListMatches = Map<String, dynamic>.from(
                                      (snapshot.data! as Event).snapshot.value);
                                  final listKeys = MyListMatches.keys;
                                  //print("the values:"+listKeys.toString());
                                  int index = -1;
                                  listListMatches.addAll(MyListMatches.values.map((value) {
                                    final nextUserMatches= UserMatches.fromRealTimeDB(
                                        Map<String, dynamic>.from(value));
                                    index++;
                                    return UserMatches(
                                        pointsgreen: nextUserMatches.pointsgreen,
                                        pointsred: nextUserMatches.pointsred,
                                        dateTime: listKeys.elementAt(index),
                                        key: listKeys.elementAt(index),
                                    );
                                  }));
                                } catch (Error) {
                                  print("erro ler:" + Error.toString());
                                  //listUserChat.clear();
                                }
                                print("tamanho lista: " +
                                    listListMatches.length.toString());
                              }
                              if (listListMatches.isEmpty) {
                                return Text("nothing",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        decorationStyle: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .decorationStyle,
                                        color: Colors.white));
                              } else {
                                return ListView.builder(
                                    itemCount: listListMatches.length,
                                    itemBuilder: (context, index) => ListMatches(
                                      userMatches: listListMatches[index],
                                    ));
                              }
                            },
                          ),
                        ),
                      ), //lista de mensagens
                    ),
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
    DatabaseReference ref = database.reference();
    return
      Expanded(
        child:
        Container(
          color: UserLoggedIn().userTeamColor=="green"? Colors.green:Colors.red,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(flex: 1),
              Padding(padding: EdgeInsets.all(20),
                child:
                Text(
                  "This is your profile, "+UserLoggedIn().userName,
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
                  "Choose your preferences, like... the team that you belong to, using the switch below.\n"
                      "Currently you belong to the group "+UserLoggedIn().userTeamColor,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith( color: Colors.white),
                ),
              ),
              Switch.adaptive(
                  value: value,
                  activeColor: Colors.white,
                  activeTrackColor: Colors.red[900],
                  onChanged: (value)=>setState(() {
                    this.value = value;
                    if(value==false) {
                      UserLoggedIn userLoggedIn = new UserLoggedIn();
                      userLoggedIn.userTeamColor = "green";
                      ref.child("/Users/"+ UserLoggedIn().userId + "/").update({
                        'teamColor': "green",
                      }).catchError((error)=> print("$error"));
                    }
                    else{
                      UserLoggedIn userLoggedIn = new UserLoggedIn();
                      userLoggedIn.userTeamColor = "red";
                      ref.child("/Users/"+ UserLoggedIn().userId + "/").update({
                        'teamColor': "red",
                      }).catchError((error)=> print("$error"));
                    }
                  })
              ),
              Spacer(flex: 1),
              /*FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: ,
                ),*/
              const Padding(padding: EdgeInsets.all(20),
                child:
                Text(
                  "The results for each match are recorded every hour, so if you open the game several times at the same"
                      " hour in the same day, you will be able to see all the records from that hour and keep changing them!",
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
