import 'package:catalyst/core/databases/cache/cache_helper.dart';

class TimeService {
  Duration _drift = Duration.zero;
  bool _hasSynced = false;
  static const String _driftKey = 'server_time_drift';
  static const String _syncedKey = 'server_time_synced';

  Future<void> init() async {
    final driftMillis = await CacheHelper.getData(key: _driftKey);
    if (driftMillis != null && driftMillis is int) {
      _drift = Duration(milliseconds: driftMillis);
    }

    final synced = await CacheHelper.getData(key: _syncedKey);
    if (synced != null && synced is bool) {
      _hasSynced = synced;
    }
  }

  void updateDrift(DateTime serverTime) {
    final now = DateTime.now();
    _drift = serverTime.difference(now);
    _hasSynced = true;
    CacheHelper.saveData(key: _driftKey, value: _drift.inMilliseconds);
    CacheHelper.saveData(key: _syncedKey, value: true);
  }

  DateTime get now => DateTime.now().add(_drift);

  Duration get drift => _drift;

  bool get hasSynced => _hasSynced;
}
