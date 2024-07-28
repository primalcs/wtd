import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class Singleton {}

class Helper extends ChangeNotifier {
  final SharedPreferences sharedPreferences;
  // static final Helper _singleton = Helper._internal();
  // factory Helper() {
  //   return _singleton;
  // }
  // Helper._internal();
  Helper({required this.sharedPreferences});

  static const String _currentListKeyName = '%curKey%';
  static const String allListsKeyName = '%allKey%';
  static const String _currentLanguage = '%languageKey%';
  static const String _currentColor = '%colorKey%';
  static const String _currentColorMode = '%colorModeKey%';

  late String initialLanguage;
  late Color initialColor;
  late bool initialColorMode;

  void loadSettings() {
    initialColor = getCurrentColor();
    initialLanguage = getCurrentLanguage();
    initialColorMode = getCurrentColorMode();
  }

  Future<bool> setSpecificList(String key, List<String> value) async {
    var res = await sharedPreferences.setStringList(key, value);
    notifyListeners();
    return res;
  }

  Future<List<String>> getSpecificList(String key) async {
    return sharedPreferences.getStringList(key) ?? [];
  }

  Future<bool> setCurrentListName(String value) async {
    var res = await sharedPreferences.setString(_currentListKeyName, value);
    notifyListeners();
    return res;
  }

  Future<String> getCurrentListName() async {
    return sharedPreferences.getString(_currentListKeyName) ?? '%default%';
  }

  Future<List<String>> getAllListsNames() async {
    return sharedPreferences.getStringList(allListsKeyName) ?? ['default'];
  }

  Future<bool> setAllListsNames(List<String> value) async {
    var res = await sharedPreferences.setStringList(allListsKeyName, value);
    notifyListeners();
    return res;
  }

  Future<bool> deleteWholeList(String value) async {
    List<String> allList =
        sharedPreferences.getStringList(allListsKeyName) ?? [];
    allList.remove(value);
    await sharedPreferences.setStringList(allListsKeyName, allList);
    var res = await sharedPreferences.remove(value);
    notifyListeners();
    return res;
  }

  String getCurrentLanguage() {
    return sharedPreferences.getString(_currentLanguage) ?? 'en';
  }

  Future<bool> setCurrentLanguage(String value) async {
    initialLanguage = value;
    var res = await sharedPreferences.setString(_currentLanguage, value);
    notifyListeners();
    return res;
  }

  Color getCurrentColor() {
    var col = sharedPreferences.getString(_currentColor) ?? '255;0;0;255';
    var cols = col.split(";");
    return Color.fromARGB(int.parse(cols[0]), int.parse(cols[1]),
        int.parse(cols[2]), int.parse(cols[3]));
  }

  Future<bool> setCurrentColor(Color v) async {
    v.alpha.toString();
    var value =
        "${v.alpha.toString()};${v.red.toString()};${v.green.toString()};${v.blue.toString()}";
    initialColor = v;
    var res = await sharedPreferences.setString(_currentColor, value);
    notifyListeners();
    return res;
  }

  bool getCurrentColorMode() {
    return sharedPreferences.getBool(_currentColorMode) ?? false;
  }

  Future<bool> setCurrentColorMode(bool value) async {
    initialColorMode = value;
    var res = await sharedPreferences.setBool(_currentColorMode, value);
    notifyListeners();
    return res;
  }
}
