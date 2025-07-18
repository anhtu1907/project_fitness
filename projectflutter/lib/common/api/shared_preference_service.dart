import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static SharedPreferences? _prefs;
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? get userId => _prefs?.getString('userId');
  static set userId(String? value) {
    if (value != null) {
      _prefs?.setString('userId', value);
    } else {
      _prefs?.remove('userId');
    }
  }

  static List<String>? get favoriteIds => _prefs?.getStringList('favoriteIds');
  static set favoriteIds(List<String>? value) {
    if (value != null) {
      _prefs?.setStringList('favoriteIds', value);
    } else {
      _prefs?.remove('favoriteIds');
    }
  }
  static String? get token => _prefs?.getString('token');

  static set token(String? value) {
    if (value != null) {
      _prefs?.setString('token', value);
    } else {
      _prefs?.remove('token');
    }
  }
}
