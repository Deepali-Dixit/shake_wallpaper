

import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:shake_wallpaper/services/phone_auth.dart';
import 'package:shake_wallpaper/utils/theme_notifier.dart';
import 'package:shake_wallpaper/values/theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    ThemeData theme=themeNotifier.getTheme();
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Theme',style: TextStyle(color: theme.accentColor)),
            contentPadding: const EdgeInsets.only(left: 16.0),
            trailing: Transform.scale(
              scale: 0.4,
              child: DayNightSwitcher(
                isDarkModeEnabled: _darkTheme,
                onStateChanged: (val) {
                  themeNotifier.setTheme(val?darkTheme:lightTheme);
                  // setState(() {
                  //   _darkTheme = val;
                  // });
                 
                },
              ),
            ),
          ),
           MaterialButton(
                child: Text('Sign out'),
                color: Colors.blue,
                onPressed: () {
                  PhoneAuth().signout();
                },
              ),
        ],
      ),
    );
  }

 
}