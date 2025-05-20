import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences? _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized');
  }

  static int? get userId => _prefs?.getInt('userId');
  static set userId(int? value) {
    if (value != null) {
      _prefs?.setInt('userId', value);
    } else {
      _prefs?.remove('userId');
    }
  }
}
