import 'package:flutter/material.dart';
import 'package:food_timer_app/assets.dart';
import 'package:food_timer_app/functions.dart';
import 'package:food_timer_app/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String rVal = "";
  List<List> timers = [];
  String userName = "";

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rVal = prefs.getString("color").toString();

    setState(
      () {
        primaryColor = getColor(rVal);
      },
    );
  }

  getUserName() async {
    final _settings = await SharedPreferences.getInstance();
    try {
      userName = _settings.getString("username")!;
    } catch (e) {
      await _settings.setString("username", "User name");
      userName = _settings.getString("username")!;
    }
    setState(
      () {},
    );
  }

  getTimers() async {
    setState(() {});
    List<dynamic> timer = [];
    List<String> timerList = [];
    SharedPreferences entries = await SharedPreferences.getInstance();
    // If this is the first time the timer entries have been requested, make a new list.

    try {
      timerList = entries.getStringList("timers")!;
    } catch (e) {
      await entries.setStringList("timers", []);
      timerList = entries.getStringList("timers")!;
    }

    for (int i = 0; i < timerList.length; i++) {
      timer = entries.getStringList(timerList[i])!;
      setState(
        () {
          timers.add(timer);
        },
      );
    }
    return true;
  }

  void initState() {
    loadColor();
    getTimers();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 20, top: 15),
                child: Text.rich(
                  TextSpan(
                    style: GoogleFonts.bitter(
                        textStyle:
                            const TextStyle(fontSize: 28, color: greyColor)),
                    children: <TextSpan>[
                      TextSpan(text: "Good " + greeting() + ",\n"),
                      TextSpan(
                          text: userName, style: TextStyle(color: primaryColor))
                    ],
                  ),
                ),
              ),
              // For each timer entry in the storage do the following: (maybe a list with all the entries and index into each one?)
              for (int i = 0; i < timers.length; i++)
                timerCard(
                  [timers[i][0], timers[i][1], timers[i][2], timers[i][3]],
                  primaryColor,
                  true,
                  context,
                ),
              // Bottom Margin Container to make space for content to be shown over the custom bottom nav bar.
              FractionallySizedBox(
                widthFactor: 1.0,
                child:
                    Container(alignment: Alignment.bottomCenter, height: 100),
              )
            ],
          ),
          // Simple custom bottom navigation bar, cant be const because it needs to update
          // ignore: prefer_const_constructors
          BottomNavBar(
            pageType: "homePage",
            parentFunction: () => {},
          )
        ],
      ),
    );
  }
}
