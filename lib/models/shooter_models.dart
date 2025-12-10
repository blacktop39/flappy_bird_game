/// 슈팅 게임 관련 모델 클래스들
/// 플레이어, 적, 총알 등의 데이터와 비즈니스 로직
library;

import 'dart:math';
import '../constants/game_constants.dart';

/// 플레이어 모델
class Player {
  /// X 좌표
  double x;

  /// Y 좌표
  double y;

  /// 체력
  int health;

  /// 마지막 발사 시간
  DateTime? lastShootTime;

  Player({
    required this.x,
    required this.y,
    this.health = PlayerConstants.maxHealth,
    this.lastShootTime,
  });

  /// 이동
  void move(double dx, double dy) {
    x += dx * GamePhysics.playerSpeed;
    y += dy * GamePhysics.playerSpeed;

    // 화면 경계 체크
    final halfSize = PlayerConstants.size / 2;
    x = x.clamp(
      halfSize,
      GameAreaConstants.width - halfSize,
    );
    y = y.clamp(
      halfSize,
      GameAreaConstants.height - halfSize,
    );
  }

  /// 발사 가능 여부
  bool canShoot() {
    if (lastShootTime == null) return true;
    final elapsed = DateTime.now().difference(lastShootTime!).inMilliseconds;
    return elapsed >= PlayerConstants.shootCooldown;
  }

  /// 발사
  Bullet? shoot(double targetX, double targetY) {
    if (!canShoot()) return null;

    lastShootTime = DateTime.now();

    // 방향 계산
    final dx = targetX - x;
    final dy = targetY - y;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance == 0) return null;

    return Bullet(
      x: x,
      y: y,
      velocityX: (dx / distance) * GamePhysics.bulletSpeed,
      velocityY: (dy / distance) * GamePhysics.bulletSpeed,
    );
  }

  /// 데미지 받기
  void takeDamage(int damage) {
    health -= damage;
    if (health < 0) health = 0;
  }

  /// 죽었는지 확인
  bool isDead() => health <= 0;

  /// 리셋
  void reset() {
    x = GameAreaConstants.width / 2;
    y = GameAreaConstants.height / 2;
    health = PlayerConstants.maxHealth;
    lastShootTime = null;
  }
}

/// 적 모델
class Enemy {
  /// X 좌표
  double x;

  /// Y 좌표
  double y;

  /// X 방향 속도
  final double velocityX;

  /// Y 방향 속도
  final double velocityY;

  /// 체력
  int health;

  Enemy({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    this.health = EnemyConstants.health,
  });

  /// 이동
  void move() {
    x += velocityX;
    y += velocityY;
  }

  /// 화면 밖으로 나갔는지 확인
  bool isOffScreen() {
    return x < -EnemyConstants.size ||
        x > GameAreaConstants.width + EnemyConstants.size ||
        y < -EnemyConstants.size ||
        y > GameAreaConstants.height + EnemyConstants.size;
  }

  /// 데미지 받기
  void takeDamage(int damage) {
    health -= damage;
  }

  /// 죽었는지 확인
  bool isDead() => health <= 0;

  /// 랜덤 적 생성 (화면 밖에서 중앙을 향해)
  factory Enemy.random(int wave) {
    final random = Random();
    final side = random.nextInt(4); // 0: 위, 1: 오른쪽, 2: 아래, 3: 왼쪽

    double x, y;
    final centerX = GameAreaConstants.width / 2;
    final centerY = GameAreaConstants.height / 2;

    // 생성 위치 결정
    switch (side) {
      case 0: // 위
        x = random.nextDouble() * GameAreaConstants.width;
        y = -EnemyConstants.size;
        break;
      case 1: // 오른쪽
        x = GameAreaConstants.width + EnemyConstants.size;
        y = random.nextDouble() * GameAreaConstants.height;
        break;
      case 2: // 아래
        x = random.nextDouble() * GameAreaConstants.width;
        y = GameAreaConstants.height + EnemyConstants.size;
        break;
      case 3: // 왼쪽
        x = -EnemyConstants.size;
        y = random.nextDouble() * GameAreaConstants.height;
        break;
      default:
        x = 0;
        y = 0;
    }

    // 중앙을 향하는 방향 계산
    final dx = centerX - x;
    final dy = centerY - y;
    final distance = sqrt(dx * dx + dy * dy);

    // 웨이브에 따라 속도 증가
    final speed = GamePhysics.enemySpeed + (wave * GamePhysics.enemySpeedIncrement);

    return Enemy(
      x: x,
      y: y,
      velocityX: (dx / distance) * speed,
      velocityY: (dy / distance) * speed,
    );
  }
}

/// 총알 모델
class Bullet {
  /// X 좌표
  double x;

  /// Y 좌표
  double y;

  /// X 방향 속도
  final double velocityX;

  /// Y 방향 속도
  final double velocityY;

  Bullet({
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
  });

  /// 이동
  void move() {
    x += velocityX;
    y += velocityY;
  }

  /// 화면 밖으로 나갔는지 확인
  bool isOffScreen() {
    return x < -BulletConstants.size ||
        x > GameAreaConstants.width + BulletConstants.size ||
        y < -BulletConstants.size ||
        y > GameAreaConstants.height + BulletConstants.size;
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

/// 게임 통계
class GameStats {
  /// 현재 점수
  int score;

  /// 최고 점수
  int bestScore;

  /// 현재 웨이브
  int wave;

  /// 총 처치한 적
  int totalKills;

  /// 총 발사한 총알
  int totalShots;

  /// 총 플레이 횟수
  int totalGames;

  GameStats({
    this.score = 0,
    this.bestScore = 0,
    this.wave = 1,
    this.totalKills = 0,
    this.totalShots = 0,
    this.totalGames = 0,
  });

  /// 적 처치
  void enemyKilled() {
    score += EnemyConstants.scoreValue;
    totalKills++;
  }

  /// 총알 발사
  void bulletShot() {
    totalShots++;
  }

  /// 웨이브 증가
  void nextWave() {
    wave++;
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
    wave = 1;
  }

  /// JSON으로 변환 (저장용)
  Map<String, dynamic> toJson() {
    return {
      'bestScore': bestScore,
      'totalKills': totalKills,
      'totalShots': totalShots,
      'totalGames': totalGames,
    };
  }

  /// JSON에서 생성 (로드용)
  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      bestScore: json['bestScore'] ?? 0,
      totalKills: json['totalKills'] ?? 0,
      totalShots: json['totalShots'] ?? 0,
      totalGames: json['totalGames'] ?? 0,
    );
  }

  /// 명중률 계산
  double get accuracy {
    return totalShots > 0 ? (totalKills / totalShots * 100) : 0;
  }
}
