import 'package:multiplayer_game/profile_screen.dart';
import 'package:rive/rive.dart';
import 'package:rive/components.dart';
import 'package:flutter/material.dart';


class StateTeamSwitch extends State<ProfileScreen>{
  late final bool value;
  StateTeamSwitch({
    required this.value
  })

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Switch.adaptive(
          value: value,
          onChanged: (value)=>setState(() {
            this.value=value;
          }));
  }

}