import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  late SharedPreferences _prefs;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setString(String item, String value) async {
    await _prefs.setString(item, value);
  }

  getString(String item) async {
    var value = _prefs.getString(item);
    return value;
  }

  void setStringList(String item, List<String> value) async {
    await _prefs.setStringList(item, value);
  }

  List<String>? getStringList(String item) {
    try {
      return _prefs.getStringList(item);
    } catch (e) {
      return [];
    }
  }
}
