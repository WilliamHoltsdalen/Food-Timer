import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:food_timer_app/functions.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'addNewPage.dart';
import 'assets.dart';
import 'editPage.dart';
import 'homePage.dart';
import 'settingsPage.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar(
      {Key? key, this.pageType, required Function this.parentFunction})
      : super(key: key);
  final pageType;
  final parentFunction;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  String rVal = "";

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rVal = prefs.getString("color").toString();

    setState(() {
      primaryColor = getColor(rVal);
    });
  }

  void initState() {
    loadColor();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bottomNavBarItemsList = bottomNavBarItems(
      widget.pageType,
      context,
      widget,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: FractionallySizedBox(
            widthFactor: 1.0,
            child: Container(
              height: 75,
              padding: const EdgeInsets.only(left: 40, right: 40),
              decoration: const BoxDecoration(color: Colors.white),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: bottomNavBarItemsList),
            ),
          ),
        ),
      ),
    );
  }
}

FractionallySizedBox timerCard(List<dynamic> timer, Color _primaryColor,
    bool functional, BuildContext context) {
  return FractionallySizedBox(
    widthFactor: 0.9,
    child: Container(
      margin: const EdgeInsets.only(top: 25),
      padding: const EdgeInsets.only(bottom: 10),
      // height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.26),
              spreadRadius: 1,
              blurRadius: 8)
        ],
      ),
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(bottom: 5, top: 5),
            height: 140,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: timer[1],
              height: 140,
            ),
          ),
          Container(
            // height: 100,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(128, 128, 128, 0.39),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, -15))
              ],
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            timer[0],
                            style: GoogleFonts.bitter(
                              textStyle: const TextStyle(
                                  fontSize: 22, color: greyColor),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text.rich(
                                TextSpan(
                                    style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: _primaryColor)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: timer[2],
                                        style: GoogleFonts.notoSans(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const TextSpan(text: "°C")
                                    ]),
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: greyColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 30),
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text.rich(
                                TextSpan(
                                    style: GoogleFonts.notoSans(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: _primaryColor)),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: timer[3].toString(),
                                        style: GoogleFonts.notoSans(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      const TextSpan(text: " min")
                                    ]),
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: greyColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      iconSize: 48,
                      color: greyColor,
                      onPressed: () {
                        if (functional) {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: EditPage(timer: timer),
                            ),
                          );
                        } else {}
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow_rounded),
                      iconSize: 84,
                      color: _primaryColor,
                      onPressed: () {
                        if (functional) {
                          logTimerExecution(timer[0], timer[3]);
                          FlutterAlarmClock.createTimer(
                              (timerMinutesIntChecker(timer[3]) * 60).toInt(),
                              skipUi: false,
                              title: timer[0]);
                        } else {}
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
