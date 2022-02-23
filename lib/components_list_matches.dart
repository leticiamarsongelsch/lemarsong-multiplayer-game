import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiplayer_game/matches.dart';

import 'clicksCircles.dart';

class ListMatches extends StatelessWidget {
  ListMatches({
    Key? key,
    required this.userMatches,
    //required this.press,
  }) : super(key: key);

  //final VoidCallback press;
  final UserMatches userMatches;

  //final StateChatScreen statcechscreen = new StateChatScreen();

  @override
  Widget build(BuildContext context) {
    return
      Container(
      //InkWell(
      /*onTap: () {
      },*/
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 4),
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: Text(
                              "points green:"+userMatches.pointsgreen!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              "points red:"+userMatches.pointsred!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ])),
            Opacity(
              opacity: 0.8,
              child: Text(
                userMatches.dateTime!,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
