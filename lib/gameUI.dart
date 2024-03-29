import 'dart:html';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/layers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image, Draggable;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flame/input.dart';
import 'package:multiplayer_game/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


late int indexLastMessage = 0;
late int pointsgreen = 1;
late int pointsred = 1;
FirebaseDatabase database = FirebaseDatabase.instance;
class GameUI extends FlameGame with HasCollidables, HasTappables{//, TapDetector
  static const description = '''''';

  @override
  Future<void> onLoad() async {
    add(ScreenCollidable());
    add(MyCollidable(Vector2.all(50)));
    add(MyCollidable2(Vector2.all(200)));
  }
  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);

}
class MyCollidable extends PositionComponent
    with HasGameRef<GameUI>, HasHitboxes, Collidable, Tappable{
  //final database = FirebaseDatabase.instance.reference();

  late Vector2 velocity;
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.green;
  bool _isCollision = false;
  final List<Collidable> activeCollisions = [];
  bool _beenPressed = false;

  MyCollidable(Vector2 position)
      : super(
    position: position,
    size: Vector2.all(60),
    anchor: Anchor.center,
  );

  //late HitboxPolygon hitbox;
  late HitboxCircle hitboxcircle;

  @override
  Future<void> onLoad() async {
    addHitbox(HitboxCircle());
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(50);
    hitboxcircle = HitboxCircle(normalizedRadius: 0.9);
    addHitbox(hitboxcircle);
    /*hitbox = HitboxPolygon([
      Vector2(0.0, -1.0),
      Vector2(-1.0, -0.1),
      Vector2(-0.2, 0.4),
      Vector2(0.2, 0.4),
      Vector2(1.0, -0.1),
    ]);
    addHitbox(hitbox);*/
  }

  @override
  void update(double dt) {
    /*if (_isWallHit) {
      removeFromParent();
      return;
    }*/
    if(_beenPressed==true){
      DatabaseReference ref = database.reference();
      DateTime dateTimenow = DateTime.now();
      print("green | "+position.storage.toString()+" | "+dateTimenow.toString());
      ref.child("/Users/"+ UserLoggedIn().userId +"/Match/"+"/"+dateTimenow.hour.toString()
          +"-"+dateTimenow.day.toString()+"-"+dateTimenow.month.toString()+"/"
      +indexLastMessage.toString()+"/").set({
        'colorCircle':'green',
        'coordinate':position.storage.toString(),
        'dateTime':dateTimenow.toString(),
        'indexLastMessage': indexLastMessage,
      }).catchError((error)=> print("$error"));
      indexLastMessage++;
      //if(UserLoggedIn().userTeamColor.toLowerCase()=="green" || identical(UserLoggedIn().userTeamColor, "green")) {
        ref.child("/Users/" + UserLoggedIn().userId + "/Match/" + "/" +
            dateTimenow.hour.toString()
            + "-" + dateTimenow.day.toString() + "-" +
            dateTimenow.month.toString() + "/").update({
          'pointsgreen': pointsgreen.toString(),
        }).catchError((error) => print("$error"));
        pointsgreen++;
      //}
    }
    _beenPressed=false;
    debugColor = _isCollision ? _collisionColor : _defaultColor;
    position.add(velocity * dt);
    _isCollision = false;
  }

  @override
  void render(Canvas canvas) {
    renderHitboxes(canvas);
    //canvas.drawCircle(Offset.infinite, 0.6, Paint()..color = const Color(0xFFFFFFFF));
  }

  @override
  bool onTapUp(_) {
    _beenPressed = false;
    return true;
  }

  @override
  bool onTapDown(_) {
    _beenPressed = true;
    angle += 1.0;
    return true;
  }

  @override
  bool onTapCancel() {
    _beenPressed = false;
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    /*if (other is ScreenCollidable) {
      _isWallHit = true;
      return;
    }*/
    _isCollision = true;
    if (!activeCollisions.contains(other)) {
      velocity.negate();
      //flipVertically();
      //flipHorizontally();
      activeCollisions.add(other);
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    activeCollisions.remove(other);
  }
}

class MyCollidable2 extends PositionComponent
    with HasGameRef<GameUI>, HasHitboxes, Collidable, Tappable{
  late Vector2 velocity;
  final _collisionColor = Colors.amber;
  final _defaultColor = Colors.red;
  bool _isCollision = false;
  final List<Collidable> activeCollisions = [];
  bool _beenPressed = false;

  MyCollidable2(Vector2 position)
      : super(
    position: position,
    size: Vector2.all(60),
    anchor: Anchor.center,
  );

  //late HitboxPolygon hitbox;
  late HitboxCircle hitboxcircle;

  @override
  Future<void> onLoad() async {
    addHitbox(HitboxCircle());
    final center = gameRef.size / 2;
    velocity = (center - position)..scaleTo(50);
    hitboxcircle = HitboxCircle(normalizedRadius: 0.9);
    addHitbox(hitboxcircle);
  }

  @override
  void update(double dt) {
    /*if (_isWallHit) {
      removeFromParent();
      return;
    }*/
    if(_beenPressed==true){
      DateTime dateTimenow = DateTime.now();
      print("red | "+position.storage.toString()+" | "+dateTimenow.toString());
      DatabaseReference ref = database.reference();
      ref.child("/Users/"+ UserLoggedIn().userId +"/Match/"+"/"+dateTimenow.hour.toString()
          +"-"+dateTimenow.day.toString()+"-"+dateTimenow.month.toString()+"/"
          +indexLastMessage.toString()+"/").set({
        'colorCircle':'red',
        'coordinate':position.storage.toString(),
        'dateTime':dateTimenow.toString(),
        'indexLastMessage': indexLastMessage,
      }).catchError((error)=> print("$error"));
      indexLastMessage++;
      //if(UserLoggedIn().userTeamColor.toLowerCase()=="red" || identical(UserLoggedIn().userTeamColor, "red")) {
        ref.child("/Users/" + UserLoggedIn().userId + "/Match/" + "/" +
            dateTimenow.hour.toString()
            + "-" + dateTimenow.day.toString() + "-" +
            dateTimenow.month.toString() + "/").update({
          'pointsred': pointsred.toString(),
        }).catchError((error) => print("$error"));
        pointsred++;
      //}
    }
    _beenPressed=false;
    debugColor = _isCollision ? _collisionColor : _defaultColor;
    position.add(velocity * dt);
    _isCollision = false;
  }

  @override
  void render(Canvas canvas) {
    renderHitboxes(canvas);
    //canvas.drawCircle(Offset.infinite, 0.6, Paint()..color = const Color(0xFFFFFFFF));
  }

  @override
  bool onTapUp(_) {
    _beenPressed = false;
    return true;
  }

  @override
  bool onTapDown(_) {
    _beenPressed = true;
    angle += 1.0;
    return true;
  }

  @override
  bool onTapCancel() {
    _beenPressed = false;
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    /*if (other is ScreenCollidable) {
      _isWallHit = true;
      return;
    }*/
    _isCollision = true;
    if (!activeCollisions.contains(other)) {
      velocity.negate();
      //flipVertically();
      //flipHorizontally();
      activeCollisions.add(other);
    }
  }

  @override
  void onCollisionEnd(Collidable other) {
    activeCollisions.remove(other);
  }
}