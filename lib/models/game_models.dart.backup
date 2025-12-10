/// 게임 관련 모델 클래스들
/// 데이터와 비즈니스 로직을 캡슐화
library;

import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// 파이프 모델
class Pipe {
  /// 파이프의 X 좌표
  double x;

  /// 위쪽 파이프 높이
  final double topHeight;

  /// 아래쪽 파이프 높이
  final double bottomHeight;

  /// 점수 획득 여부
  bool scored;

  Pipe({
    required this.x,
    required this.topHeight,
    required this.bottomHeight,
    this.scored = false,
  });

  /// 파이프를 왼쪽으로 이동
  void move() {
    x -= PipeConstants.speed;
  }

  /// 파이프가 화면 밖으로 나갔는지 확인
  bool isOffScreen() {
    return x < -PipeConstants.width - 50;
  }

  /// 파이프가 점수 획득 지점을 통과했는지 확인
  bool shouldScore() {
    return !scored && x < BirdConstants.xPosition - PipeConstants.width;
  }

  /// 랜덤 파이프 생성 팩토리
  factory Pipe.random() {
    final random = Random();
    final topHeight = PipeConstants.minHeight +
        random.nextDouble() *
            (PipeConstants.maxHeight - PipeConstants.minHeight);

    return Pipe(
      x: GameAreaConstants.width,
      topHeight: topHeight,
      bottomHeight: GameAreaConstants.height - topHeight - PipeConstants.gapHeight,
    );
  }
}

/// 새 모델
class Bird {
  /// Y 좌표 (중앙을 0으로)
  double y;

  /// 수직 속도
  double velocity;

  Bird({
    this.y = 0,
    this.velocity = 0,
  });

  /// 점프
  void jump() {
    velocity = GamePhysics.jumpVelocity;
  }

  /// 물리 업데이트
  void update() {
    // 중력 적용
    velocity += GamePhysics.gravity;

    // 속도 제한
    velocity = velocity.clamp(
      GamePhysics.maxRiseVelocity,
      GamePhysics.maxFallVelocity,
    );

    // 위치 업데이트
    y += velocity;

    // 경계 체크
    if (y < GameAreaConstants.ceilingBoundary) {
      y = GameAreaConstants.ceilingBoundary;
      velocity = 0;
    } else if (y > GameAreaConstants.floorBoundary) {
      y = GameAreaConstants.floorBoundary;
      velocity = 0;
    }
  }

  /// 회전 각도 계산 (라디안)
  double getRotation() {
    return (velocity * BirdConstants.rotationFactor)
        .clamp(-BirdConstants.maxRotation, BirdConstants.maxRotation);
  }

  /// 바닥이나 천장에 충돌했는지 확인
  bool isOutOfBounds() {
    return y <= GameAreaConstants.ceilingBoundary ||
        y >= GameAreaConstants.floorBoundary;
  }

  /// 파이프와 충돌했는지 확인
  bool collidesWithPipe(Pipe pipe) {
    // X축 충돌 범위 체크
    if (pipe.x < CollisionConstants.pipeXRangeLeft ||
        pipe.x > CollisionConstants.pipeXRangeRight) {
      return false;
    }

    // Y축 충돌 체크
    final topCollisionPoint = -GameAreaConstants.halfHeight +
        pipe.topHeight +
        BirdConstants.radius +
        CollisionConstants.safetyMargin;

    final bottomCollisionPoint = GameAreaConstants.halfHeight -
        pipe.bottomHeight -
        BirdConstants.radius -
        CollisionConstants.safetyMargin;

    return y < topCollisionPoint || y > bottomCollisionPoint;
  }

  /// 리셋
  void reset() {
    y = 0;
    velocity = 0;
  }
}

/// 게임 상태
enum GameState {
  /// 게임 시작 전
  ready,

  /// 게임 진행 중
  playing,

  /// 게임 오버
  gameOver,

  /// 일시정지
  paused,
}

/// 파티클 모델 (점수 획득 시 효과)
class Particle {
  /// X 좌표
  double x;

  /// Y 좌표
  double y;

  /// X 방향 속도
  final double vx;

  /// Y 방향 속도
  final double vy;

  /// 크기
  final double size;

  /// 색상
  final Color color;

  /// 생성 시간
  final DateTime createdAt;

  /// 수명 (밀리초)
  final int lifetime;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.lifetime,
  }) : createdAt = DateTime.now();

  /// 파티클 업데이트
  void update() {
    x += vx;
    y += vy;
  }

  /// 파티클이 만료되었는지 확인
  bool isExpired() {
    return DateTime.now().difference(createdAt).inMilliseconds > lifetime;
  }

  /// 불투명도 계산 (시간에 따라 페이드아웃)
  double getOpacity() {
    final elapsed = DateTime.now().difference(createdAt).inMilliseconds;
    return 1.0 - (elapsed / lifetime);
  }

  /// 랜덤 파티클 버스트 생성
  static List<Particle> burst({
    required double x,
    required double y,
    required Color color,
    int count = ParticleConstants.burstCount,
  }) {
    final random = Random();
    final particles = <Particle>[];

    for (int i = 0; i < count; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final speed = ParticleConstants.minVelocity +
          random.nextDouble() *
              (ParticleConstants.maxVelocity - ParticleConstants.minVelocity);

      particles.add(Particle(
        x: x,
        y: y,
        vx: cos(angle) * speed,
        vy: sin(angle) * speed,
        size: ParticleConstants.minSize +
            random.nextDouble() *
                (ParticleConstants.maxSize - ParticleConstants.minSize),
        color: color,
        lifetime: GameTiming.particleLifetime,
      ));
    }

    return particles;
  }
}

/// 게임 통계
class GameStats {
  /// 현재 점수
  int score;

  /// 최고 점수
  int bestScore;

  /// 총 플레이 횟수
  int totalGames;

  /// 총 점프 횟수
  int totalJumps;

  /// 총 획득 점수
  int totalScore;

  GameStats({
    this.score = 0,
    this.bestScore = 0,
    this.totalGames = 0,
    this.totalJumps = 0,
    this.totalScore = 0,
  });

  /// 점수 증가
  void incrementScore() {
    score++;
    totalScore++;
  }

  /// 점프 카운트 증가
  void incrementJumps() {
    totalJumps++;
  }

  /// 게임 종료 시 통계 업데이트
  void endGame() {
    if (score > bestScore) {
      bestScore = score;
    }
    totalGames++;
  }

  /// 게임 리셋
  void resetGame() {
    score = 0;
  }

  /// JSON으로 변환 (저장용)
  Map<String, dynamic> toJson() {
    return {
      'bestScore': bestScore,
      'totalGames': totalGames,
      'totalJumps': totalJumps,
      'totalScore': totalScore,
    };
  }

  /// JSON에서 생성 (로드용)
  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      bestScore: json['bestScore'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
      totalJumps: json['totalJumps'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
    );
  }

  /// 평균 점수 계산
  double get averageScore {
    return totalGames > 0 ? totalScore / totalGames : 0;
  }
}
