/// 게임의 모든 상수값을 중앙에서 관리하는 파일
library;

import 'package:flutter/material.dart';

/// 게임 물리 상수
class GamePhysics {
  GamePhysics._();

  /// 플레이어 이동 속도
  static const double playerSpeed = 5.0;

  /// 총알 속도
  static const double bulletSpeed = 8.0;

  /// 적 기본 속도
  static const double enemySpeed = 2.0;

  /// 적 속도 증가율 (웨이브마다)
  static const double enemySpeedIncrement = 0.3;
}

/// 적 관련 상수
class EnemyConstants {
  EnemyConstants._();

  /// 적 크기
  static const double size = 30.0;

  /// 적 생성 간격 (밀리초)
  static const int spawnInterval = 1000;

  /// 초기 웨이브당 적 수
  static const int initialEnemiesPerWave = 3;

  /// 웨이브당 적 증가 수
  static const int enemiesIncrement = 2;

  /// 적 체력
  static const int health = 1;

  /// 적 제거 시 점수
  static const int scoreValue = 10;
}

/// 플레이어 관련 상수
class PlayerConstants {
  PlayerConstants._();

  /// 플레이어 크기
  static const double size = 40.0;

  /// 플레이어 반지름 (충돌 감지용)
  static const double radius = 20.0;

  /// 사격 쿨다운 (밀리초)
  static const int shootCooldown = 200;

  /// 플레이어 체력
  static const int maxHealth = 3;
}

/// 총알 관련 상수
class BulletConstants {
  BulletConstants._();

  /// 총알 크기
  static const double size = 8.0;

  /// 총알 반지름
  static const double radius = 4.0;

  /// 총알 데미지
  static const int damage = 1;
}

/// 게임 영역 크기
class GameAreaConstants {
  GameAreaConstants._();

  /// 게임 영역 너비
  static const double width = 400.0;

  /// 게임 영역 높이
  static const double height = 600.0;

  /// 게임 영역 반 높이
  static const double halfHeight = height / 2;

  /// 천장 경계
  static const double ceilingBoundary = -halfHeight + 10;

  /// 바닥 경계
  static const double floorBoundary = halfHeight - 10;
}

/// 충돌 감지 상수
class CollisionConstants {
  CollisionConstants._();

  /// 원형 충돌 감지 (반지름 합 기반)
  static bool circleCollision(
    double x1, double y1, double r1,
    double x2, double y2, double r2,
  ) {
    final dx = x1 - x2;
    final dy = y1 - y2;
    final distance = dx * dx + dy * dy;
    final radiusSum = r1 + r2;
    return distance < radiusSum * radiusSum;
  }
}

/// UI 관련 상수
class UIConstants {
  UIConstants._();

  /// 점수판 폰트 크기
  static const double scoreFontSize = 32.0;

  /// 게임오버 타이틀 폰트 크기
  static const double gameOverTitleSize = 40.0;

  /// 게임오버 점수 폰트 크기
  static const double gameOverScoreSize = 24.0;

  /// 버튼 폰트 크기
  static const double buttonFontSize = 20.0;

  /// 애니메이션 지속시간 (밀리초)
  static const int animationDuration = 300;

  /// 모달 둥근 모서리
  static const double modalBorderRadius = 25.0;

  /// 버튼 패딩
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 50,
    vertical: 18,
  );
}

/// 색상 팔레트
class GameColors {
  GameColors._();

  /// 배경 그라데이션 시작
  static const Color bgGradientStart = Color(0xFF1a1a2e);

  /// 배경 그라데이션 끝
  static const Color bgGradientEnd = Color(0xFF16213e);

  /// 플레이어 색상
  static const Color player = Color(0xFF00d4ff);

  /// 플레이어 테두리
  static const Color playerBorder = Color(0xFF0095b3);

  /// 적 색상
  static const Color enemy = Color(0xFFff4757);

  /// 적 테두리
  static const Color enemyBorder = Color(0xFFd63447);

  /// 총알 색상
  static const Color bullet = Color(0xFFffa502);

  /// 총알 빛
  static const Color bulletGlow = Color(0xFFff6348);

  /// 점수판 배경
  static Color scoreBackground = Colors.white.withOpacity(0.9);

  /// 점수판 텍스트
  static const Color scoreText = Color(0xFFE65100);

  /// 모달 배경
  static const Color modalOverlay = Color(0x88000000);

  /// 모달 컨테이너 배경
  static const Color modalBackground = Colors.white;

  /// 구름 색
  static Color cloudColor = Colors.white.withOpacity(0.7);

  /// 버튼 색
  static const Color buttonPrimary = Color(0xFFFF6F00);

  /// 버튼 텍스트 색
  static const Color buttonText = Colors.white;

  /// 그림자 색
  static Color shadowColor = Colors.black.withOpacity(0.3);
}

/// 게임 타이밍 상수
class GameTiming {
  GameTiming._();

  /// 게임 루프 업데이트 간격 (밀리초) - 60 FPS
  static const int gameLoopInterval = 16;

  /// 파티클 수명 (밀리초)
  static const int particleLifetime = 800;

  /// 파티클 생성 간격 (밀리초)
  static const int particleSpawnInterval = 50;
}

/// 오디오 파일 경로 (향후 사운드 추가용)
class AudioAssets {
  AudioAssets._();

  /// 점프 효과음
  static const String jump = 'assets/audio/jump.wav';

  /// 점수 획득 효과음
  static const String score = 'assets/audio/score.wav';

  /// 충돌 효과음
  static const String hit = 'assets/audio/hit.wav';

  /// 배경음악
  static const String backgroundMusic = 'assets/audio/background.mp3';
}

/// 파티클 효과 상수
class ParticleConstants {
  ParticleConstants._();

  /// 파티클 최소 크기
  static const double minSize = 2.0;

  /// 파티클 최대 크기
  static const double maxSize = 6.0;

  /// 파티클 최소 속도
  static const double minVelocity = 1.0;

  /// 파티클 최대 속도
  static const double maxVelocity = 4.0;

  /// 한 번에 생성할 파티클 수
  static const int burstCount = 10;
}
