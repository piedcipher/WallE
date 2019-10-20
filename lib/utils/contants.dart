import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const kPreferenceBrightnessKey = 'kPreferenceBrightnessKey';
const kPreferencePrimarySwatchKey = 'kPreferencePrimarySwatchKey';
const kPreferenceAccentColorKey = 'kPreferenceAccentColorKey';

Database kDatabase;
const kTable = 'favorites';

const Map<String, Color> primarySwatches = {
  'Blue': Colors.blue,
  'Indigo': Colors.indigo,
  'Pink': Colors.pink,
  'Yellow': Colors.yellow,
  'Green': Colors.green,
  'Light Green': Colors.lightGreen,
  'Orange': Colors.orange,
  'Deep Orange': Colors.deepOrange,
  'Purple': Colors.purple,
  'Deep Purple': Colors.deepPurple,
  'Brown': Colors.brown,
  'Lime': Colors.lime,
  'Light Blue': Colors.lightBlue,
  'Red': Colors.red,
  'Amber': Colors.amber,
  'Cyan': Colors.cyan,
  'Teal': Colors.teal,
};

const Map<String, MaterialAccentColor> accentColors = {
  'Indigo': Colors.indigoAccent,
  'Blue': Colors.blueAccent,
  'Green': Colors.greenAccent,
  'Red': Colors.redAccent,
  'Yellow': Colors.yellowAccent,
  'Amber': Colors.amberAccent,
  'Pink': Colors.pinkAccent,
  'Purple': Colors.purpleAccent,
  'Deep Purple': Colors.deepPurpleAccent,
  'Orange': Colors.orangeAccent,
  'Deep Orange': Colors.deepOrangeAccent,
  'Light Blue': Colors.lightBlueAccent,
  'Light Green': Colors.lightGreenAccent,
  'Cyan': Colors.cyanAccent,
  'Lime': Colors.limeAccent,
  'Teal': Colors.tealAccent,
};
