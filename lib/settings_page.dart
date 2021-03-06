// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_timer_app/assets.dart';
import 'package:food_timer_app/home_page.dart';
import 'package:food_timer_app/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'functions.dart';
import 'log_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String rVal = "";
  bool darkCover = false;
  String darkCoverPrompt = "";

  late String userName;
  TextEditingController userNameController =
      TextEditingController(text: "UserName");

  // Get name of the user from SharedPreferences, and assign
  // it to the texteditingcontroller `userNameController┬┤
  getUserName() async {
    final _settings = await SharedPreferences.getInstance();

    setState(() {
      userName = _settings.getString("username")!;
    });

    userNameController = TextEditingController(text: userName);
  }

  // Get primary color from SharedPreferences
  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    rVal = prefs.getString("color").toString();

    setState(() {
      primaryColor = getColor(rVal);
    });
  }

  // Toggle on or off the black, low opacity, filter over content.
  toggleDarkCover(String type) {
    setState(() {
      if (type == "Clear settings") {
        darkCoverPrompt = "Do you wish to clear the settings?";
      } else if (type == "Clear logs") {
        darkCoverPrompt = "Do you wish to clear the logs?";
      } else if (type == "Remove timers") {
        darkCoverPrompt = "Do you wish to remove all timers?";
      } else {
        darkCoverPrompt = "";
      }
      darkCover = !darkCover;
    });
  }

  @override
  void initState() {
    super.initState();
    loadColor();
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
                padding: const EdgeInsets.only(left: 25, top: 15, right: 25),
                child: Text(
                  "App settings",
                  style: GoogleFonts.bitter(
                    textStyle: TextStyle(fontSize: 32, color: primaryColor),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 35, right: 25),
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: greyColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "Customization",
                  style: GoogleFonts.bitter(
                    textStyle: const TextStyle(fontSize: 24, color: greyColor),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 25, right: 25),
                height: 40,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Color theme",
                          style: GoogleFonts.bitter(
                            textStyle:
                                const TextStyle(fontSize: 20, color: greyColor),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: greenColor,
                            border: (() {
                              if (primaryColor == greenColor) {
                                return Border.all(
                                    color: darkGreyColor, width: 2.5);
                              }
                            }()),
                          ),
                          child: InkWell(
                            onTap: () => setState(
                              () {
                                setThemeColor("green");
                                loadColor();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: orangeColor,
                            border: (() {
                              if (primaryColor == orangeColor) {
                                return Border.all(
                                    color: darkGreyColor, width: 2.5);
                              }
                            }()),
                          ),
                          child: InkWell(
                            onTap: () => setState(
                              () {
                                setThemeColor("orange");
                                loadColor();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: purpleColor,
                            border: (() {
                              if (primaryColor == purpleColor) {
                                return Border.all(
                                    color: darkGreyColor, width: 2.5);
                              }
                            }()),
                          ),
                          child: InkWell(
                            onTap: () => setState(
                              () {
                                setThemeColor("purple");
                                loadColor();
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: blueColor,
                            border: (() {
                              if (primaryColor == blueColor) {
                                return Border.all(
                                    color: darkGreyColor, width: 2.5);
                              }
                            }()),
                          ),
                          child: InkWell(
                            onTap: () => setState(
                              () {
                                setThemeColor("blue");
                                loadColor();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 15, right: 25),
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: "User name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelStyle: const TextStyle(color: greyColor),
                  ),
                  onChanged: (text) {
                    setState(() {
                      if (text == "") {
                        userName = "User name";
                      } else {
                        userName = text;
                      }
                    });
                  },
                  onSubmitted: (text) {
                    setUserName(text);
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 35, right: 25),
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: greyColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "Miscellaneous",
                  style: GoogleFonts.bitter(
                    textStyle: const TextStyle(fontSize: 24, color: greyColor),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 25, top: 25, right: 25),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const LogPage(),
                          ));
                    },
                    label: const Text("Timer logs"),
                    icon: Icon(Icons.list, color: primaryColor),
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(
                          color: greyColor,
                          width: 1,
                        ),
                        textStyle: GoogleFonts.bitter(
                          textStyle: const TextStyle(fontSize: 24),
                        ),
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                          bottom: 10,
                        ),
                        primary: greyColor),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 25, top: 35, right: 25),
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: greyColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "Danger Zone",
                  style: GoogleFonts.bitter(
                    textStyle: const TextStyle(fontSize: 24, color: greyColor),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(left: 25, top: 25, right: 25),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () {
                          // deleteAllSettings();
                          toggleDarkCover("Clear settings");
                        },
                      );
                    },
                    label: const Text("Clear settings"),
                    icon: const Icon(Icons.delete, color: cancelColor),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        color: greyColor,
                        width: 1,
                      ),
                      textStyle: GoogleFonts.bitter(
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 15,
                        bottom: 10,
                      ),
                      primary: greyColor,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(left: 25, top: 12.5),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () {
                          // deleteAllLogs();
                          toggleDarkCover("Clear logs");
                        },
                      );
                    },
                    label: const Text("Clear logs"),
                    icon: const Icon(Icons.delete, color: cancelColor),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        color: greyColor,
                        width: 1,
                      ),
                      textStyle: GoogleFonts.bitter(
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 15,
                        bottom: 10,
                      ),
                      primary: greyColor,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 240,
                  margin: const EdgeInsets.only(left: 25, top: 12.5, right: 25),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(
                        () {
                          toggleDarkCover("Remove timers");
                        },
                      );
                    },
                    label: const Text("Remove timers"),
                    icon: const Icon(Icons.delete, color: cancelColor),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        color: greyColor,
                        width: 1,
                      ),
                      textStyle: GoogleFonts.bitter(
                        textStyle: const TextStyle(fontSize: 24),
                      ),
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 10,
                        right: 15,
                        bottom: 10,
                      ),
                      primary: greyColor,
                      alignment: Alignment.centerLeft,
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
            pageType: "settingsPage",
            parentFunction: () => {},
          ),
          if (darkCover)
            Stack(children: [
              FractionallySizedBox(
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: GestureDetector(
                  onTap: () => {toggleDarkCover("")},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Container(
                    height: 205,
                    padding:
                        const EdgeInsets.only(left: 40, top: 20, right: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          darkCoverPrompt,
                          style: GoogleFonts.bitter(
                            textStyle: const TextStyle(
                                fontSize: 28, color: darkGreyColor),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              OutlinedButton(
                                onPressed: () {
                                  toggleDarkCover("");
                                },
                                child: const Text("No"),
                                style: OutlinedButton.styleFrom(
                                    fixedSize: const Size(135, 55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: const BorderSide(
                                      color: cancelColor,
                                      width: 2,
                                    ),
                                    textStyle: GoogleFonts.bitter(
                                      textStyle: const TextStyle(fontSize: 28),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      right: 15,
                                      bottom: 10,
                                    ),
                                    primary: darkGreyColor),
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  if (darkCoverPrompt ==
                                      "Do you wish to clear the settings?") {
                                    await deleteAllSettings();
                                  } else if (darkCoverPrompt ==
                                      "Do you wish to clear the logs?") {
                                    await deleteAllLogs();
                                  } else if (darkCoverPrompt ==
                                      "Do you wish to remove all timers?") {
                                    await deleteAllTimers();
                                  }
                                  setState(() {});
                                  Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.fade,
                                      child: const SettingsPage(),
                                    ),
                                  );
                                },
                                child: const Text("Yes"),
                                style: OutlinedButton.styleFrom(
                                    fixedSize: const Size(135, 55),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: const BorderSide(
                                      color: greenColor,
                                      width: 2,
                                    ),
                                    textStyle: GoogleFonts.bitter(
                                      textStyle: const TextStyle(fontSize: 28),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      top: 10,
                                      right: 15,
                                      bottom: 10,
                                    ),
                                    primary: darkGreyColor),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
