import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static const String _currentListKeyName = '%curKey%';
  static const String allListsKeyName = '%allKey%';

  static Future<bool> setSpecificList(String key, List<String> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setStringList(key, value);
  }

  static Future<List<String>> getSpecificList(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(key) ?? [];
  }

  static Future<bool> setCurrentListName(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(_currentListKeyName, value);
  }

  static Future<String> getCurrentListName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_currentListKeyName) ?? '%default%';
  }

  static Future<List<String>> getAllListsNames() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getStringList(allListsKeyName) ?? ['default'];
  }

  static Future<bool> setAllListsNames(List<String> value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setStringList(allListsKeyName, value);
  }

  static Future<bool> deleteWholeList(String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> allList =
        sharedPreferences.getStringList(allListsKeyName) ?? [];
    allList.remove(value);
    await sharedPreferences.setStringList(allListsKeyName, allList);
    return await sharedPreferences.remove(value);
  }
}
