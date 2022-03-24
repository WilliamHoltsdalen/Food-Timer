// ignore: file_names
import 'package:flutter/material.dart';
import 'package:food_timer_app/assets.dart';
import 'package:food_timer_app/functions.dart';
import 'package:food_timer_app/homePage.dart';
import 'package:food_timer_app/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.timer}) : super(key: key);
  final timer;

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  late String title = widget.timer[0];
  late TextEditingController titleController =
      TextEditingController(text: title);

  late String imageURL = widget.timer[1];
  late TextEditingController imageURLController =
      TextEditingController(text: imageURL);

  late String temp = widget.timer[2];
  late TextEditingController tempController = TextEditingController(text: temp);

  late String minutes = widget.timer[3];
  late TextEditingController minutesController =
      TextEditingController(text: minutes);

  bool darkCover = false;
  String colorRVal = "";
  late String oldTimerTitle = "";

  void loadColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    colorRVal = prefs.getString("color").toString();

    setState(() {
      primaryColor = getColor(colorRVal);
    });
  }

  // Action handler for navbar items (Exit and Confirm)
  void actionHandler(String command) async {
    if (command == "delete") {
      toggleDarkCover();
    } else if (command == "confirm") {
      confirmNewTimer();
    }
  }

  // Toggle on or off the black, low opacity, filter over content.
  toggleDarkCover() {
    setState(() {
      darkCover = !darkCover;
    });
  }

  void goToHomePage() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: MyHomePage(),
      ),
    );
  }

  Future<bool> removeOldTimer(title) async {
    List<String> timerList = [];
    final _settings = await SharedPreferences.getInstance();

    timerList = _settings.getStringList("timers")!;

    if (timerList.contains(title)) {
      print("removing");
      await _settings.remove(title);
      timerList.remove(title);
      await _settings.setStringList("timers", timerList);
    }
    return true;
  }

  void confirmNewTimer() async {
    await removeOldTimer(oldTimerTitle);
    await newTimerEntry(title, imageURL, temp, minutes);
    setState(() {});
    goToHomePage();
  }

  void initState() {
    loadColor();
    oldTimerTitle = title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: Center(
                  child: Text(
                    "Edit Timer",
                    style: GoogleFonts.bitter(
                      textStyle:
                          const TextStyle(fontSize: 28, color: darkGreyColor),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: "Title",
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
                              title = "Title";
                            } else {
                              title = text;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      margin: const EdgeInsets.only(top: 25),
                      child: TextField(
                        controller: imageURLController,
                        decoration: InputDecoration(
                          labelText: "Image URL",
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
                            imageURL = text;
                          });
                        },
                      ),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 25, right: 12.5),
                            child: TextField(
                              controller: tempController,
                              decoration: InputDecoration(
                                labelText: "Temp",
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
                                  temp = text;
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(top: 25, left: 12.5),
                            child: TextField(
                              controller: minutesController,
                              decoration: InputDecoration(
                                labelText: "Min",
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
                                  minutes = text;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Preview",
                        style: GoogleFonts.bitter(
                          textStyle: const TextStyle(
                              fontSize: 26, color: darkGreyColor),
                        ),
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
                  ),
                  timerCard([title, imageURL, temp, minutes], primaryColor,
                      false, context),
                ],
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
            pageType: "editPage",
            parentFunction: actionHandler,
          ),
          if (darkCover)
            Stack(children: [
              FractionallySizedBox(
                heightFactor: 1.0,
                widthFactor: 1.0,
                child: GestureDetector(
                  onTap: () => {toggleDarkCover()},
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
                          "Do you want to remove this timer?",
                          style: GoogleFonts.bitter(
                            textStyle: const TextStyle(
                                fontSize: 28, color: darkGreyColor),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              OutlinedButton(
                                onPressed: () {
                                  toggleDarkCover();
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
                                  await removeOldTimer(oldTimerTitle);
                                  goToHomePage();
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
