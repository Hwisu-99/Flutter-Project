import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _sharedPreferences;

  static Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static double getGoalWeight() {
    return _sharedPreferences?.getDouble("currentUserName") ?? 0.0;
  }

  static Future<void> setGoalWeight(double goalWeight) async {
    await _sharedPreferences?.setDouble("currentUserName", goalWeight);
  }

  static double getCurrentHeight() {
    return _sharedPreferences?.getDouble("currentHeight") ?? 0.0;
  }

  static Future<void> setCurrentHeight(double currentHeight) async {
    await _sharedPreferences?.setDouble("currentHeight", currentHeight);
  }
}