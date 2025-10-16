import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {
  Future<void> saveSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('size', size);
  }

  Future<int> loadSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('size') ?? 10;
  }

  Future<void> saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('color', color.value);
  }

  Future<Color> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    int colorValue = prefs.getInt('color') ?? Colors.black.value;
    return Color(colorValue);
  }
}