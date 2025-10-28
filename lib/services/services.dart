import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedServices {
  Future<void> saveSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('size', size);
  }

  Future<int> loadSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('size') ?? 10;
  }

  Future<void> saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedColor', color.value);
  }

  Future<Color> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('selectedColor') ?? Colors.black.value;
    return Color(colorValue);
  }

  Future<void> saveGridFlat(List<Color> gridColors) async {
    final prefs = await SharedPreferences.getInstance();
    final colorValues = gridColors.map((c) => c.value).toList();
    await prefs.setString('pixel_grid_flat', jsonEncode(colorValues));
  }

  Future<List<Color>?> loadGridFlat() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('pixel_grid_flat');
    if (data == null) return null;
    final colorValues = List<int>.from(jsonDecode(data));
    return colorValues.map((v) => Color(v)).toList();
  }

  Future<void> saveCreations(List<String> creations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pixel_creations', jsonEncode(creations));
  }

  Future<List<String>> loadCreations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('pixel_creations');
    if (data == null) return <String>[];
    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((e) => e.toString()).toList();
  }

  Future<void> saveDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, value);
  }

  Future<double?> loadDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }
}
