// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Check if SharedPreferences is initialized
  bool get isInitialized => _prefs != null;

  /// Set methods
  Future<bool> setString(String key, String value) async =>
      _prefs!.setString(key, value);

  Future<bool> setBool(String key, bool value) async =>
      _prefs!.setBool(key, value);

  Future<bool> setDouble(String key, double value) async =>
      _prefs!.setDouble(key, value);

  Future<bool> setInt(String key, int value) async =>
      _prefs!.setInt(key, value);

  Future<void> setStringList(String key, List<String> lst) async =>
      _prefs!.setStringList(key, lst);

  List<String>? getStringList(String key) => _prefs!.getStringList(key);

  /// Get methods
  String? getString(String key) => _prefs!.getString(key);
  bool? getBool(String key) => _prefs!.getBool(key);
  double? getDouble(String key) => _prefs!.getDouble(key);
  int? getInt(String key) => _prefs!.getInt(key);

  /// Utility methods
  bool contains(String key) => _prefs!.containsKey(key);

  Future<bool> remove(String key) async => _prefs!.remove(key);

  Future<bool> clearAll() async => _prefs!.clear();
}
