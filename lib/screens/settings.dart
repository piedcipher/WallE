import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walle/utils/contants.dart';

class SettingsScreen extends StatefulWidget {
  final Function updateBrightness;
  final Function updatePrimarySwatch;
  final Function updateAccentColor;

  SettingsScreen(
      this.updateBrightness, this.updatePrimarySwatch, this.updateAccentColor);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SharedPreferences _sharedPreferences;
  int _brightness;
  String _primarySwatch;
  String _accentColor;

  @override
  void initState() {
    super.initState();
    getDefaults();
  }

  void getDefaults() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _brightness = _sharedPreferences.getInt(kPreferenceBrightnessKey) ?? 1;
      _primarySwatch =
          _sharedPreferences.getString(kPreferencePrimarySwatchKey) ?? 'Indigo';
      _accentColor =
          _sharedPreferences.getString(kPreferenceAccentColorKey) ?? 'Pink';
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
                DropdownButtonFormField(
                  value: _primarySwatch,
                  onChanged: (newPrimarySwatch) async {
                    setState(() {
                      _primarySwatch = newPrimarySwatch;
                    });
                    _sharedPreferences.setString(
                        kPreferencePrimarySwatchKey, newPrimarySwatch);
                    widget
                        .updatePrimarySwatch(primarySwatches[newPrimarySwatch]);
                  },
                  decoration: InputDecoration(
                    labelText: 'Primary Swatch',
                  ),
                  items: [
                    ...primarySwatches.keys.map(
                      (primarySwatch) => DropdownMenuItem(
                        child: Text(primarySwatch),
                        value: primarySwatch,
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  value: _accentColor,
                  onChanged: (newAccentColor) async {
                    setState(() {
                      _accentColor = newAccentColor;
                    });
                    _sharedPreferences.setString(
                        kPreferenceAccentColorKey, newAccentColor);
                    widget.updateAccentColor(accentColors[newAccentColor]);
                  },
                  decoration: InputDecoration(
                    labelText: 'Accent Color',
                  ),
                  items: [
                    ...accentColors.keys.map(
                      (accentColor) => DropdownMenuItem(
                        child: Text(accentColor),
                        value: accentColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
