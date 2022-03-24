// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:food_timer_app/homePage.dart';
import 'package:food_timer_app/settingsPage.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addNewPage.dart';
import 'assets.dart';

Color returnColor = Colors.black;

String greeting() {
  final now = DateTime.now();
  int hour = int.parse(DateFormat("H").format(now));

  if (hour < 12) {
    return "morning";
  } else if (hour > 12 && hour < 18) {
    return "afternoon";
  } else {
    return "evening";
  }
}

Color getColor(String color) {
  if (color == "green") {
    returnColor = greenColor;
  } else if (color == "orange") {
    returnColor = orangeColor;
  } else if (color == "purple") {
    returnColor = purpleColor;
  } else if (color == "blue") {
    returnColor = blueColor;
  }
  return returnColor;
}

void setUserName(String name) async {
  final _settings = await SharedPreferences.getInstance();
  await _settings.setString("username", name);
  print(name);
}

void setThemeColor(String newColor) async {
  final _settings = await SharedPreferences.getInstance();
  await _settings.setString("color", newColor);
}

Future<bool> newTimerEntry(
  String title,
  String imageURL,
  String temp,
  String minutes,
) async {
  if (title == "" || imageURL == "" || temp == "" || minutes == "") {
    return false;
  }
  List<String> timerList = [];

  final _settings = await SharedPreferences.getInstance();

  timerList = _settings.getStringList("timers")!;

  if (timerList.contains(title)) {
    await _settings.remove(title);
    timerList.remove(title);
  }

  timerList.add(title);
  await _settings.setStringList("timers", timerList);

  await _settings.setStringList(title, [title, imageURL, temp, minutes]);
  return true;
}

logTimerExecution(String title, String duration) async {
  final _settings = await SharedPreferences.getInstance();
  List<String> logList = [];
  final now = new DateTime.now();
  String dateAndTime = DateFormat("MMMd").add_Hm().format(now);
  // print(dateAndTime);

  try {
    logList = _settings.getStringList("logs")!;
  } catch (e) {
    _settings.setStringList("logs", []);
    logList = _settings.getStringList("logs")!;
  }

  logList.add("$title, $duration min, " + dateAndTime);
  await _settings.setStringList("logs", logList);
}

timerMinutesIntChecker(String minutes) {
  num val = num.parse(minutes);
  if (val is int) {
    return val.toInt();
  } else {
    return val.toDouble();
  }
}

void deleteAllSettings() async {
  final _settings = await SharedPreferences.getInstance();
  await _settings.setString("username", "User name");
  await _settings.setString("color", "green");
}

void deleteAllTimers() async {
  final _settings = await SharedPreferences.getInstance();
  List<String> timerList = _settings.getStringList("timers")!;
  for (int i = 0; i < timerList.length; i++) {
    await _settings.remove(timerList[i]);
  }
  await _settings.remove("timers");
}

Widget bottomNavBarItem(widget, IconData icon, double iconSize, Color iconColor,
    BuildContext buildContext, StatefulWidget page, bool enabledStatus,
    {String? functionParameter}) {
  return IconButton(
    icon: Icon(icon),
    iconSize: iconSize,
    color: iconColor,
    disabledColor: primaryColor,
    onPressed: enabledStatus
        ? () {
            if (functionParameter == null) {
              Navigator.pushReplacement(
                buildContext,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: page,
                ),
              );
            } else {
              widget.parentFunction(functionParameter);
            }
          }
        : null,
  );
}

List<Widget> bottomNavBarItems(pageType, BuildContext buildContext, widget) {
  if (pageType == "homePage") {
    return [
      bottomNavBarItem(
        widget,
        Icons.settings_outlined,
        48,
        greyColor,
        buildContext,
        const SettingsPage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        false,
      ),
      bottomNavBarItem(
        widget,
        Icons.add_rounded,
        56,
        greyColor,
        buildContext,
        const AddNewPage(),
        true,
      ),
    ];
  } else if (pageType == "settingsPage") {
    return [
      bottomNavBarItem(
        widget,
        Icons.settings_outlined,
        48,
        greyColor,
        buildContext,
        const SettingsPage(),
        false,
      ),
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.add_rounded,
        56,
        greyColor,
        buildContext,
        const AddNewPage(),
        true,
      ),
    ];
  } else if (pageType == "addNewPage") {
    return [
      bottomNavBarItem(
        widget,
        Icons.close_rounded,
        56,
        cancelColor,
        buildContext,
        const SettingsPage(),
        true,
        functionParameter: "cancel",
      ),
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.check_rounded,
        56,
        greenColor,
        buildContext,
        const AddNewPage(),
        true,
        functionParameter: "confirm",
      ),
    ];
  } else if (pageType == "editPage") {
    return [
      bottomNavBarItem(
        widget,
        Icons.close_rounded,
        56,
        cancelColor,
        buildContext,
        const SettingsPage(),
        true,
        functionParameter: "delete",
      ),
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.check_rounded,
        56,
        greenColor,
        buildContext,
        const AddNewPage(),
        true,
        functionParameter: "confirm",
      ),
    ];
  } else if (pageType == "logPage") {
    return [
      bottomNavBarItem(
        widget,
        Icons.arrow_back_ios_rounded,
        48,
        greyColor,
        buildContext,
        const SettingsPage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        true,
      ),
      bottomNavBarItem(
        widget,
        Icons.add_rounded,
        56,
        greyColor,
        buildContext,
        const AddNewPage(),
        true,
      ),
    ];
  } else {
    return [
      bottomNavBarItem(
        widget,
        Icons.home_rounded,
        48,
        greyColor,
        buildContext,
        MyHomePage(),
        true,
      ),
    ];
  }
}

void printstate(number) {
  print("Number is $number");
}
