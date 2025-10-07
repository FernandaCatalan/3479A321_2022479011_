import 'package:flutter/material.dart';

class ConfigurationData extends ChangeNotifier {
  int _size = 10;
  Color _selectedColor = Colors.black;

  int get size => _size;
  Color get selectedColor => _selectedColor;

  void setSize(int newSize) {
    _size = newSize;
    notifyListeners(); 
  }

  void setColor(Color newColor) {
    _selectedColor = newColor;
    notifyListeners(); 
  }
}