import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Singleton {}

class Helper extends ChangeNotifier {
  static final Helper _singleton = Helper._internal();
  factory Helper() {
    return _singleton;
  }
  Helper._internal();

  static const String _currentListKeyName = '%curKey%';
  static const String allListsKeyName = '%allKey%';

  Future<bool> setSpecificList(String key, List<String> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = await sharedPreferences.setStringList(key, value);
    notifyListeners();
    return res;
  }

  Future<List<String>> getSpecificList(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key) ?? [];
  }

  Future<bool> setCurrentListName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = await sharedPreferences.setString(_currentListKeyName, value);
    notifyListeners();
    return res;
  }

  Future<String> getCurrentListName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_currentListKeyName) ?? '%default%';
  }

  Future<List<String>> getAllListsNames() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(allListsKeyName) ?? ['default'];
  }

  Future<bool> setAllListsNames(List<String> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var res = await sharedPreferences.setStringList(allListsKeyName, value);
    notifyListeners();
    return res;
  }

  Future<bool> deleteWholeList(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> allList =
        sharedPreferences.getStringList(allListsKeyName) ?? [];
    allList.remove(value);
    await sharedPreferences.setStringList(allListsKeyName, allList);
    var res = await sharedPreferences.remove(value);
    notifyListeners();
    return res;
  }
}
