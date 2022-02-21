import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_game/components_list_clicks.dart';
import 'package:multiplayer_game/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'clicksCircles.dart';
import 'login_screen.dart';
import 'gameUI.dart';

class GameScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool gamepaused = false;
  GameUI gameUI = GameUI();

  //final database = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    _setValuesUserLogged();
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    final bool useMobileLayout = shortestSide < 560;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 500,
              color: Colors.white,
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (useMobileLayout)
                      _topSideScreen(context),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "You belong to the " +
                            UserLoggedIn().userTeamColor +
                            " team.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Tap on the circle with your team color as much times as you can",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.blueAccent),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: _theGameScreen(),
                    ),
                  ],
                ),
              ),
            ),
            if (!useMobileLayout) _rightSideScreen(context),
          ],
        ),
      ),
    );
    //_theGameScreen();
  }

  void _setValuesUserLogged() {
    UserLoggedIn _userLogged = UserLoggedIn();
    _userLogged.userEmail = FirebaseAuth.instance.currentUser!.email.toString();
    _userLogged.userName =
        FirebaseAuth.instance.currentUser!.displayName.toString();
    _userLogged.userId = FirebaseAuth.instance.currentUser!.uid.toString();
  }

  _rightSideScreen(BuildContext context) {
    //final RdbUserRef = database.child("/Users/"+UserLoggedIn().userId+"/");
    return Expanded(
      child: Container(
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              message: "Exit",
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () => _openLoginScreen(context),
              ),
            ),
            /*
            SizedBox(
              height: 300,
              child: Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder(
                    stream: RdbUserRef.orderByKey().onValue,
                    builder: (context, snapshot) {
                      final listListClick = <UserTry>[];
                      if (snapshot.hasData) {
                        try {
                          final MyListClick = Map<String, dynamic>.from(
                              (snapshot.data! as Event).snapshot.value);
                          final listKeys = MyListClick.keys;
                          //print("the values:"+listKeys.toString());
                          int index = -1;
                          listListClick.addAll(MyListClick.values.map((value) {
                            final nextUserTry = UserTry.fromRealTimeDB(
                                Map<String, dynamic>.from(value));
                            index++;
                            return UserTry(
                                colorCircle: nextUserTry.colorCircle,
                                coordinate: nextUserTry.coordinate,
                                dateTime: nextUserTry.dateTime,
                                key: listKeys.elementAt(index),
                                indexLastClick: nextUserTry.indexLastClick
                            );
                          }));
                        } catch (Error) {
                          print("erro ler:" + Error.toString());
                          //listUserChat.clear();
                        }
                        print("tamanho lista: " +
                            listListClick.length.toString());
                      }
                      if (listListClick.isEmpty) {
                        return Text("nothing",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                decorationStyle: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .decorationStyle,
                                color: Colors.blue));
                      } else {
                        return ListView.builder(
                            itemCount: listListClick.length,
                            itemBuilder: (context, index) => ListClick(
                              userTry: listListClick[index],
                              /*press: () {
                                //print("função de setar click ok");
                                setState(() {
                                  //currentStudentName = listUsersChat[index].nameStudent!;
                                });
                              },*/
                            ));
                      }
                    },
                  ),
                ),
              ), //lista de mensagens
            ),*/
            Spacer(flex: 1,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "© 2022 Letícia Marson Gelschleiter. All rights reserved.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _topSideScreen(BuildContext context) {
    return
      Container(
        height: 50,
        color: Colors.blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "© 2022 Letícia Marson Gelschleiter. All rights reserved.",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 10, color: Colors.white),
              ),
            ),
            Spacer(flex: 1,),
            Tooltip(
              message: "Exit",
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                onPressed: () => _openLoginScreen(context),
              ),
            ),
          ],
        ),
    );
  }

  _openLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  _theGameScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Tooltip(
          message: "Pause/Continue",
          child: IconButton(
            icon: Icon(
              Icons.play_circle_filled,
              color: Colors.blue,
            ),
            onPressed: () {
              if (gamepaused == true)
                gameUI.resumeEngine();
              else
                gameUI.pauseEngine();
              gamepaused = !gamepaused;
            },
          ),
        ),
        /*Column(
            children: [
              Row(
                children: <Widget>[
                  TextButton(
                      onPressed: () => gameUI.pauseEngine(),
                      child: Text("Pause")),
                  TextButton(
                      onPressed: () => gameUI.resumeEngine(),
                      child: Text("Continue")),
                ],
              ),
            ],
          ),*/
        Container(
          width: 500,
          height: 400,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blue, width: 6)),
          child: Stack(
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
              Positioned.fill(
                  child: GameWidget(
                game: gameUI,
              )),
            ],
          ),
        )
      ],
    );
  }
}
