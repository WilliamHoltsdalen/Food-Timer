// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:food_timer_app/assets.dart';
import 'package:food_timer_app/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String rVal = "";
  List<String> logs = [];

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rVal = prefs.getString("color").toString();
    setState(() {
      primaryColor = getColor(rVal);
    });
  }

  getTimerLogs() async {
    final _settings = await SharedPreferences.getInstance();

    try {
      logs = _settings.getStringList("logs")!;
    } catch (e) {
      _settings.setStringList("logs", []);
      logs = _settings.getStringList("logs")!;
    }
    print(logs);
  }

  void initState() {
    loadColor();
    getTimerLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 25, top: 15, right: 25),
                child: Text(
                  "Timer logs",
                  style: GoogleFonts.bitter(
                    textStyle: TextStyle(fontSize: 32, color: primaryColor),
                  ),
                ),
              ),
              for (int i = logs.length; i > 0; i--)
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    margin: const EdgeInsets.only(left: 25, top: 25, right: 25),
                    // height: 40,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: greyColor,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      logs[i - 1],
                      style: GoogleFonts.bitter(
                        textStyle:
                            const TextStyle(fontSize: 17, color: greyColor),
                      ),
                    ),
                  ),
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
            pageType: "logPage",
            parentFunction: () => {},
          ),
        ],
      ),
    );
  }
}
