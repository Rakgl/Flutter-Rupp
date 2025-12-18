import 'package:storage/storage.dart';

const String _languageKey = 'language';
// by default app locale is km
const String _defaultLanguage = "km";

class AppLocaleStorage {
  AppLocaleStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  // save locale
  Future<void> saveLanguage(String language) async {
    try {
      await _storage.write(key: _languageKey, value: language);
    } catch (e) {
      rethrow;
    }
  }

  // get locale
  Future<String> getLanguage() async {
    try {
      final response = await _storage.read(key: _languageKey);

      if (response == null) {
        return _defaultLanguage;
      }
      return response;
    } catch (e) {
      return _defaultLanguage;
    }
  }
}
