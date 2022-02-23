import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'clicksCircles.dart';

class ListClick extends StatelessWidget {
  ListClick({
    Key? key,
    required this.userTry,
    //required this.press,
  }) : super(key: key);

  //final VoidCallback press;
  final UserTry userTry;

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
                              userTry.coordinate!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              userTry.colorCircle!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ])),
            Opacity(
              opacity: 0.8,
              child: Text(
                userTry.dateTime!,
                style: TextStyle(
                    fontSize: 8,
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
