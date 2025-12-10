/// 게임의 모든 상수값을 중앙에서 관리하는 파일
library;

import 'package:flutter/material.dart';

/// 게임 물리 상수
class GamePhysics {
  GamePhysics._();

  /// 중력 가속도
  static const double gravity = 0.6;

  /// 점프 시 초기 속도
  static const double jumpVelocity = -11.0;

  /// 최대 낙하 속도 (터미널 속도)
  static const double maxFallVelocity = 15.0;

  /// 최대 상승 속도
  static const double maxRiseVelocity = -15.0;
}

/// 파이프 관련 상수
class PipeConstants {
  PipeConstants._();

  /// 파이프 이동 속도 (픽셀/프레임)
  static const double speed = 3.0;

  /// 파이프 너비
  static const double width = 60.0;

  /// 파이프 사이 간격
  static const double gapHeight = 180.0;

  /// 파이프 최소 높이
  static const double minHeight = 80.0;

  /// 파이프 최대 높이
  static const double maxHeight = 280.0;

  /// 파이프 생성 간격 (밀리초)
  static const int spawnInterval = 2000;

  /// 파이프 캡 높이
  static const double capHeight = 30.0;

  /// 파이프 캡 추가 너비 (양쪽)
  static const double capExtraWidth = 10.0;
}

/// 새 관련 상수
class BirdConstants {
  BirdConstants._();

  /// 새의 너비
  static const double width = 40.0;

  /// 새의 높이
  static const double height = 30.0;

  /// 새의 반지름 (충돌 감지용)
  static const double radius = 15.0;

  /// 새의 X 위치 (화면에서 고정)
  static const double xPosition = 150.0;

  /// 회전 각도 계산 계수
  static const double rotationFactor = 0.04;

  /// 최대 회전 각도 (라디안)
  static const double maxRotation = 1.5;

  /// 날개짓 애니메이션 주기 (밀리초)
  static const int wingFlapDuration = 300;
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

  /// 파이프 충돌 감지 X 범위 (좌측)
  static const double pipeXRangeLeft = -50.0;

  /// 파이프 충돌 감지 X 범위 (우측)
  static const double pipeXRangeRight = 50.0;

  /// 충돌 안전 마진
  static const double safetyMargin = 35.0;
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

  /// 하늘 그라데이션 시작
  static const Color skyGradientStart = Color(0xFF87CEEB);

  /// 하늘 그라데이션 끝
  static const Color skyGradientEnd = Color(0xFF98FB98);

  /// 파이프 그라데이션 밝은색
  static const Color pipeLightGreen = Color(0xFF66BB6A);

  /// 파이프 그라데이션 어두운색
  static const Color pipeDarkGreen = Color(0xFF2E7D32);

  /// 파이프 테두리
  static const Color pipeBorder = Color(0xFF1B5E20);

  /// 새 몸통 색
  static const Color birdBody = Color(0xFFFDD835);

  /// 새 테두리/부리 색
  static const Color birdAccent = Color(0xFFFF6F00);

  /// 새 눈 색
  static const Color birdEye = Colors.black;

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
