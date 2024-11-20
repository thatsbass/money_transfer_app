import 'package:get_storage/get_storage.dart';

class StorageService {
  final _box = GetStorage();
  
  // Clés de stockage
  static const String keyUser = 'user';
  static const String keyToken = 'token';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyTheme = 'theme';
  static const String keyLanguage = 'language';

  // Méthodes pour l'utilisateur
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _box.write(keyUser, user);
  }

  Map<String, dynamic>? getUser() {
    return _box.read(keyUser);
  }

  // Méthodes pour le token
  Future<void> saveToken(String token) async {
    await _box.write(keyToken, token);
  }

  String? getToken() {
    return _box.read(keyToken);
  }

  // Méthodes pour l'état de connexion
  Future<void> setLoggedIn(bool value) async {
    await _box.write(keyIsLoggedIn, value);
  }

  bool isLoggedIn() {
    return _box.read(keyIsLoggedIn) ?? false;
  }

  // Méthode pour effacer toutes les données
  Future<void> clearAll() async {
    await _box.erase();
  }
}