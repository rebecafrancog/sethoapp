import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/model_user.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyToken = 'jwt_token';
  static const _keyRole = 'user_role';
  static const _keyUserId = 'user_id';

  static Future<void> saveAuthData({
    required String token,
    required UserRole role,
    required String userId,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRole, value: role.name);
    await _storage.write(key: _keyUserId, value: userId);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  static Future<UserRole?> getRole() async {
    final roleStr = await _storage.read(key: _keyRole);
    if (roleStr == null) return null;
    return roleStr == UserRole.ong.name ? UserRole.ong : UserRole.voluntario;
  }

  static Future<void> clearAuth() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRole);
    await _storage.delete(key: _keyUserId);
  }
}