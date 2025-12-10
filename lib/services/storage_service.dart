/// 로컬 스토리지 관리 서비스
/// SharedPreferences를 사용한 영구 저장
library;

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shooter_models.dart';

/// 스토리지 서비스 싱글톤
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  /// SharedPreferences 인스턴스
  SharedPreferences? _prefs;

  /// 저장 키
  static const String _keyGameStats = 'game_stats';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keyMusicEnabled = 'music_enabled';

  /// 초기화
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 게임 통계 저장
  Future<void> saveGameStats(GameStats stats) async {
    if (_prefs == null) await init();
    final json = jsonEncode(stats.toJson());
    await _prefs!.setString(_keyGameStats, json);
  }

  /// 게임 통계 로드
  Future<GameStats> loadGameStats() async {
    if (_prefs == null) await init();
    final jsonString = _prefs!.getString(_keyGameStats);

    if (jsonString == null) {
      return GameStats();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return GameStats.fromJson(json);
    } catch (e) {
      // 파싱 오류 시 기본값 반환
      return GameStats();
    }
  }

  /// 사운드 효과 설정 저장
  Future<void> setSoundEnabled(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_keySoundEnabled, enabled);
  }

  /// 사운드 효과 설정 로드
  Future<bool> getSoundEnabled() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(_keySoundEnabled) ?? true;
  }

  /// 배경음악 설정 저장
  Future<void> setMusicEnabled(bool enabled) async {
    if (_prefs == null) await init();
    await _prefs!.setBool(_keyMusicEnabled, enabled);
  }

  /// 배경음악 설정 로드
  Future<bool> getMusicEnabled() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(_keyMusicEnabled) ?? true;
  }

  /// 모든 데이터 삭제 (초기화)
  Future<void> clearAll() async {
    if (_prefs == null) await init();
    await _prefs!.clear();
  }

  /// 최고 점수만 빠르게 가져오기
  Future<int> getBestScore() async {
    final stats = await loadGameStats();
    return stats.bestScore;
  }

  /// 최고 점수만 빠르게 저장하기
  Future<void> saveBestScore(int score) async {
    final stats = await loadGameStats();
    if (score > stats.bestScore) {
      stats.bestScore = score;
      await saveGameStats(stats);
    }
  }
}
