import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferences? _prefs;
  static SharedPreferencesManager? _instance;

  factory SharedPreferencesManager() {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
    }
    return _instance!;
  }

  SharedPreferencesManager._();

  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs!;
  }
}
