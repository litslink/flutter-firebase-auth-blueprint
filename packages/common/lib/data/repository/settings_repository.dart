import 'package:firebase_database/firebase_database.dart';

class SettingsRepository {
  final FirebaseDatabase _database;

  SettingsRepository(this._database);

  Future<bool> isNotificationEnabled(String userId) async {
    final data = await _database.reference()
      .child(userId)
      .child('settings')
      .once();
    return data.value != null
      ? data.value['notification'] as bool
      : false;
  }

  Future<void> enableNotification(String userId) async {
    await _setNotificationStatus(userId, true);
  }

  Future<void> disableNotification(String userId) async {
    await _setNotificationStatus(userId, false);
  }

  Future<void> _setNotificationStatus(String userId, bool isEnabled) async {
    final data = {
      'notification': isEnabled
    };
    _database.reference()
      .child(userId)
      .child('settings')
      .set(data);
  }
}
