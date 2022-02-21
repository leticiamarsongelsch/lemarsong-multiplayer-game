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
    return InkWell(
      onTap: () {
        /*try {
          press.call();
        } catch (Error) {
          print("Erro:$Error");
        }*/
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 20 * 0.75),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20 / 4),
                child:
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 260),
                            child: Text(
                              userTry.coordinate!,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 300),
                            child: Text(
                              userTry.colorCircle!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue),
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
                    color: Colors.blue),
              ),
            )
          ],
        ),
      ),
    );
  }
}
