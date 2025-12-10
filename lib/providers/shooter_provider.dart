/// 슈팅 게임 상태 관리 Provider (Riverpod)
/// Professional 상태 관리 패턴
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/shooter_models.dart';
import '../constants/game_constants.dart';
import '../services/storage_service.dart';

/// 게임 상태 관리 클래스
class ShooterGameController extends StateNotifier<ShooterGameState> {
  ShooterGameController() : super(ShooterGameState.initial()) {
    _loadStats();
  }

  Timer? _gameTimer;
  Timer? _enemySpawnTimer;

  /// 게임 통계 로드
  Future<void> _loadStats() async {
    final bestScore = await StorageService.instance.getBestScore();
    state = state.copyWith(
      stats: GameStats(
        bestScore: bestScore,
      ),
    );
  }

  /// 게임 시작
  void startGame() {
    state = state.copyWith(
      gameState: GameState.playing,
      player: Player(
        x: GameAreaConstants.width / 2,
        y: GameAreaConstants.height / 2,
      ),
      enemies: [],
      bullets: [],
    );

    state.stats.resetGame();

    // 게임 루프 시작 (60 FPS)
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _updateGame(),
    );

    // 적 생성 타이머
    _startEnemySpawner();
  }

  /// 적 생성 타이머 시작
  void _startEnemySpawner() {
    _enemySpawnTimer?.cancel();
    _enemySpawnTimer = Timer.periodic(
      const Duration(milliseconds: EnemyConstants.spawnInterval),
      (_) => _spawnEnemies(),
    );
  }

  /// 적 생성
  void _spawnEnemies() {
    if (state.gameState != GameState.playing) return;

    final enemyCount = EnemyConstants.initialEnemiesPerWave +
        (state.stats.wave - 1) * EnemyConstants.enemiesIncrement;

    final newEnemies = <Enemy>[];
    for (int i = 0; i < enemyCount; i++) {
      newEnemies.add(Enemy.random(state.stats.wave));
    }

    state = state.copyWith(
      enemies: [...state.enemies, ...newEnemies],
    );

    // 다음 웨이브
    state.stats.nextWave();
  }

  /// 게임 업데이트
  void _updateGame() {
    if (state.gameState != GameState.playing) return;

    // 플레이어 이동 (키보드 입력은 메인에서 처리)

    // 총알 이동
    final updatedBullets = <Bullet>[];
    for (final bullet in state.bullets) {
      bullet.move();
      if (!bullet.isOffScreen()) {
        updatedBullets.add(bullet);
      }
    }

    // 적 이동
    final updatedEnemies = <Enemy>[];
    for (final enemy in state.enemies) {
      enemy.move();

      // 플레이어와 충돌 체크
      if (CollisionConstants.circleCollision(
        state.player.x,
        state.player.y,
        PlayerConstants.radius,
        enemy.x,
        enemy.y,
        EnemyConstants.size / 2,
      )) {
        state.player.takeDamage(1);
        enemy.takeDamage(999); // 적도 제거
      }

      // 총알과 충돌 체크
      for (final bullet in updatedBullets.toList()) {
        if (CollisionConstants.circleCollision(
          bullet.x,
          bullet.y,
          BulletConstants.radius,
          enemy.x,
          enemy.y,
          EnemyConstants.size / 2,
        )) {
          enemy.takeDamage(BulletConstants.damage);
          updatedBullets.remove(bullet);
          break;
        }
      }

      // 적이 죽지 않았고 화면 안에 있으면 유지
      if (!enemy.isDead() && !enemy.isOffScreen()) {
        updatedEnemies.add(enemy);
      } else if (enemy.isDead()) {
        state.stats.enemyKilled();
      }
    }

    // 플레이어 죽음 체크
    if (state.player.isDead()) {
      _endGame();
      return;
    }

    state = state.copyWith(
      bullets: updatedBullets,
      enemies: updatedEnemies,
    );
  }

  /// 플레이어 이동
  void movePlayer(double dx, double dy) {
    if (state.gameState != GameState.playing) return;
    state.player.move(dx, dy);
    state = state.copyWith(); // UI 업데이트 트리거
  }

  /// 발사
  void shoot(double targetX, double targetY) {
    if (state.gameState == GameState.gameOver) {
      restartGame();
      return;
    }

    if (state.gameState == GameState.ready) {
      startGame();
      return;
    }

    if (state.gameState == GameState.playing) {
      final bullet = state.player.shoot(targetX, targetY);
      if (bullet != null) {
        state.stats.bulletShot();
        state = state.copyWith(
          bullets: [...state.bullets, bullet],
        );
      }
    }
  }

  /// 게임 종료
  void _endGame() {
    _gameTimer?.cancel();
    _enemySpawnTimer?.cancel();

    state.stats.endGame();

    // 통계 저장 (나중에 구현)
    StorageService.instance.saveBestScore(state.stats.bestScore);

    state = state.copyWith(gameState: GameState.gameOver);
  }

  /// 게임 재시작
  void restartGame() {
    _gameTimer?.cancel();
    _enemySpawnTimer?.cancel();

    state = state.copyWith(
      gameState: GameState.ready,
      player: Player(
        x: GameAreaConstants.width / 2,
        y: GameAreaConstants.height / 2,
      ),
      enemies: [],
      bullets: [],
    );
  }

  /// 일시정지/재개
  void togglePause() {
    if (state.gameState == GameState.playing) {
      _gameTimer?.cancel();
      _enemySpawnTimer?.cancel();
      state = state.copyWith(gameState: GameState.paused);
    } else if (state.gameState == GameState.paused) {
      startGame();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _enemySpawnTimer?.cancel();
    super.dispose();
  }
}

/// 게임 컨트롤러 상태
class ShooterGameState {
  final GameState gameState;
  final Player player;
  final List<Enemy> enemies;
  final List<Bullet> bullets;
  final GameStats stats;

  ShooterGameState({
    required this.gameState,
    required this.player,
    required this.enemies,
    required this.bullets,
    required this.stats,
  });

  factory ShooterGameState.initial() {
    return ShooterGameState(
      gameState: GameState.ready,
      player: Player(
        x: GameAreaConstants.width / 2,
        y: GameAreaConstants.height / 2,
      ),
      enemies: [],
      bullets: [],
      stats: GameStats(),
    );
  }

  ShooterGameState copyWith({
    GameState? gameState,
    Player? player,
    List<Enemy>? enemies,
    List<Bullet>? bullets,
    GameStats? stats,
  }) {
    return ShooterGameState(
      gameState: gameState ?? this.gameState,
      player: player ?? this.player,
      enemies: enemies ?? this.enemies,
      bullets: bullets ?? this.bullets,
      stats: stats ?? this.stats,
    );
  }
}

/// 게임 컨트롤러 프로바이더
final shooterGameControllerProvider =
    StateNotifierProvider<ShooterGameController, ShooterGameState>(
  (ref) => ShooterGameController(),
);
