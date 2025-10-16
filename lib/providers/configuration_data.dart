import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/services.dart';

class ConfigurationData extends ChangeNotifier {
  final SharedServices _prefsService;

  int _size = 10;
  Color _selectedColor = Colors.black;

  int get size => _size;
  Color get selectedColor => _selectedColor;

  ConfigurationData(this._prefsService){
    _loadPreferences();
  }

  Future<void> setSize(int newSize) async {
    _size = newSize;
    await _prefsService.saveSize(newSize);
    notifyListeners();
  }

  Future<void> setColor(Color newColor) async{
    _selectedColor = newColor;
    await _prefsService.saveColor(newColor);
    notifyListeners(); 
  }

  Future<void> _loadPreferences() async {
    _size = await _prefsService.loadSize();
    _selectedColor = await _prefsService.loadColor();
    notifyListeners();
  }
}
