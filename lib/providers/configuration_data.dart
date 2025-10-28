import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';

class ConfigurationData extends ChangeNotifier {
  final SharedServices _prefsService;

  int _size = 10;
  Color _selectedColor = Colors.black;
  List<String> _creations = [];

  int get size => _size;
  Color get selectedColor => _selectedColor;
  List<String> get creations => _creations;

  double _backgroundOpacity = 0.5;

  double get backgroundOpacity => _backgroundOpacity;

  void setBackgroundOpacity(double value) {
    _backgroundOpacity = value;
    _prefsService.saveDouble('backgroundOpacity', value);
    notifyListeners();
  }

  ConfigurationData(this._prefsService) {
    _loadPreferences();
  }

  Future<void> setSize(int newSize) async {
    _size = newSize;
    await _prefsService.saveSize(newSize);
    notifyListeners();
  }

  Future<void> setColor(Color newColor) async {
    _selectedColor = newColor;
    await _prefsService.saveColor(newColor);
    notifyListeners();
  }

  Future<void> _loadPreferences() async {
    _size = await _prefsService.loadSize();
    _selectedColor = await _prefsService.loadColor();
    _creations = await _prefsService.loadCreations();
    _backgroundOpacity = await _prefsService.loadDouble('backgroundOpacity') ?? 0.5;
    notifyListeners();
  }

  Future<void> addCreation(String filePath) async {
    _creations.add(filePath);
    await _prefsService.saveCreations(_creations);
    notifyListeners();
  }
}
