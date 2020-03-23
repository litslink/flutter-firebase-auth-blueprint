import 'package:firebase_database/firebase_database.dart';

class SettingsRepository {
  final FirebaseDatabase database;

  SettingsRepository(this.database);

  Future<bool> isNotificationEnabled(String userId) async {
    final data = await database.reference()
        .child('settings')
        .child(userId)
        .once();
    return data.value != null ? data.value['notification'] as bool : false;
  }

  Future<void> enableNotification(String userId) async {
    await _setNotificationStatus(userId, true);
  }

  Future<void> disableNotification(String userId) async {
    await _setNotificationStatus(userId, false);
  }

  Future<void> _setNotificationStatus(String userId, bool isEnabled) async {
    final data = { 'notification': isEnabled };
    database.reference()
        .child('settings')
        .child(userId)
        .set(data);
  }
}
