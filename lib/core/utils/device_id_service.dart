import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class DeviceIdService {
  static const _key = 'device_id';
  static String? _cached;

  /// Returns a stable unique ID for this device.
  /// Generated once and persisted in SharedPreferences.
  static Future<String> getDeviceId() async {
    if (_cached != null) return _cached!;
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString(_key);
    if (id == null) {
      id = _generateId();
      await prefs.setString(_key, id);
    }
    _cached = id;
    return id;
  }

  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rng = Random.secure();
    return List.generate(20, (_) => chars[rng.nextInt(chars.length)]).join();
  }
}
