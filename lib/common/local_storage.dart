import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{

    SharedPreferences? _prefs;

    Future<void> _initiatePrefs() async {
        _prefs = await SharedPreferences.getInstance();
    }

    Future<String> getString( String key ) async {
        await _initiatePrefs();
        return _prefs?.getString(key) ?? "";
    }

    Future<void> setString( String key, String object ) async {
        await _initiatePrefs();
        await _prefs?.setString(key, object);
    }

    Future<void> setListOfString( List<String> keys, List<String> strings ) async {
        await _initiatePrefs();

        for (var key in keys) { 
          _prefs?.setString(key, strings[keys.indexOf(key)]);
        }
    }
    
    Future<void> logout() async {
        await _initiatePrefs();
        await _prefs!.clear();
    }
}