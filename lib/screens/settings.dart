import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walle/utils/contants.dart';

class SettingsScreen extends StatefulWidget {
  final Function updateBrightness;

  SettingsScreen(this.updateBrightness);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences _sharedPreferences;
  int _brightness;

  @override
  void initState() {
    super.initState();
    getDefaults();
  }

  void getDefaults() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _brightness = _sharedPreferences.getInt(kPreferenceBrightnessKey) ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: <Widget>[
                DropdownButtonFormField(
                  value: _brightness,
                  onChanged: (newBrightness) async {
                    setState(() {
                      _brightness = newBrightness;
                    });
                    _sharedPreferences.setInt(
                        kPreferenceBrightnessKey, newBrightness);
                    widget.updateBrightness(newBrightness == 0
                        ? Brightness.dark
                        : Brightness.light);
                  },
                  decoration: InputDecoration(
                    labelText: 'Brightness',
                  ),
                  items: [
                    DropdownMenuItem(
                      child: Text('Dark'),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text('Light'),
                      value: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
