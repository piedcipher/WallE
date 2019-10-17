import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:walle/screens/details.dart';
import 'package:walle/screens/favorites.dart';
import 'package:walle/screens/home.dart';
import 'package:walle/screens/settings.dart';

import 'package:walle/utils/db_provider.dart';
import 'package:walle/utils/contants.dart';

void main() async {
  runApp(App());
  kDatabase = await DatabaseProvider.open();
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  SharedPreferences _sharedPreferences;
  Brightness _brightness = Brightness.light;

  @override
  void initState() {
    super.initState();
    getDefaults();
  }

  void getDefaults() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _brightness = _sharedPreferences.getInt(kPreferenceBrightnessKey) == 0
        ? Brightness.dark
        : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: _brightness,
        primarySwatch: Colors.indigo,
        accentColor: Colors.pinkAccent,
      ),
      debugShowCheckedModeBanner: false,
      title: 'WallE',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(updateBrightness),
        '/details': (context) => DetailsScreen(),
        '/favorites': (context) => FavoritesScreen(),
      },
    );
  }

  void updateBrightness(Brightness brightness) async {
    setState(() {
      _brightness = brightness;
    });
  }
}
