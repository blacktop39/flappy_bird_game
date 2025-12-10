/// 게임 상태 관리 Provider (Riverpod)
/// Professional 상태 관리 패턴
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_models.dart';
import '../services/storage_service.dart';

/// 게임 상태 관리 클래스
class GameController extends StateNotifier<GameControllerState> {
  GameController() : super(GameControllerState.initial()) {
    _loadStats();
  }

  Timer? _gameTimer;
  Timer? _pipeTimer;

  /// 게임 통계 로드
  Future<void> _loadStats() async {
    final stats = await StorageService.instance.loadGameStats();
    state = state.copyWith(stats: stats);
  }

  /// 게임 시작
  void startGame() {
    state = state.copyWith(
      gameState: GameState.playing,
      bird: Bird(),
      pipes: [],
    );

    state.stats.resetGame();

    // 게임 루프 시작 (60 FPS)
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (_) => _updateGame(),
    );

    // 파이프 생성 타이머
    _pipeTimer = Timer.periodic(
      const Duration(milliseconds: 2000),
      (_) => _addPipe(),
    );
  }

  /// 게임 업데이트
  void _updateGame() {
    if (state.gameState != GameState.playing) return;

    // 새 업데이트
    state.bird.update();

    // 파이프 이동 및 점수 체크
    final updatedPipes = <Pipe>[];
    for (final pipe in state.pipes) {
      pipe.move();

      if (pipe.shouldScore()) {
        pipe.scored = true;
        state.stats.incrementScore();
        // 점수 획득 파티클 생성
        _createScoreParticles();
      }

      if (!pipe.isOffScreen()) {
        updatedPipes.add(pipe);
      }
    }

    // 파티클 업데이트
    final updatedParticles = <Particle>[];
    for (final particle in state.particles) {
      particle.update();
      if (!particle.isExpired()) {
        updatedParticles.add(particle);
      }
    }

    // 충돌 체크
    if (_checkCollision()) {
      _endGame();
      return;
    }

    state = state.copyWith(
      pipes: updatedPipes,
      particles: updatedParticles,
    );
  }

  /// 파이프 추가
  void _addPipe() {
    if (state.gameState != GameState.playing) return;

    final pipes = [...state.pipes, Pipe.random()];
    state = state.copyWith(pipes: pipes);
  }

  /// 점프
  void jump() {
    if (state.gameState == GameState.gameOver) {
      restartGame();
      return;
    }

    if (state.gameState == GameState.ready) {
      startGame();
    }

    if (state.gameState == GameState.playing) {
      state.bird.jump();
      state.stats.incrementJumps();
      state = state.copyWith(); // UI 업데이트 트리거
    }
  }

  /// 충돌 체크
  bool _checkCollision() {
    // 경계 체크
    if (state.bird.isOutOfBounds()) {
      return true;
    }

    // 파이프 충돌 체크
    for (final pipe in state.pipes) {
      if (state.bird.collidesWithPipe(pipe)) {
        return true;
      }
    }

    return false;
  }

  /// 게임 종료
  void _endGame() {
    _gameTimer?.cancel();
    _pipeTimer?.cancel();

    state.stats.endGame();
    StorageService.instance.saveGameStats(state.stats);

    state = state.copyWith(gameState: GameState.gameOver);
  }

  /// 게임 재시작
  void restartGame() {
    _gameTimer?.cancel();
    _pipeTimer?.cancel();

    state = state.copyWith(
      gameState: GameState.ready,
      bird: Bird(),
      pipes: [],
      particles: [],
    );
  }

  /// 점수 획득 파티클 생성
  void _createScoreParticles() {
    final particles = [
      ...state.particles,
      ...Particle.burst(
        x: 200,
        y: 50,
        color: const Color(0xFFFFD700), // 금색
      ),
    ];
    state = state.copyWith(particles: particles);
  }

  /// 일시정지/재개
  void togglePause() {
    if (state.gameState == GameState.playing) {
      _gameTimer?.cancel();
      _pipeTimer?.cancel();
      state = state.copyWith(gameState: GameState.paused);
    } else if (state.gameState == GameState.paused) {
      startGame();
    }
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _pipeTimer?.cancel();
    super.dispose();
  }
}

/// 게임 컨트롤러 상태
class GameControllerState {
  final GameState gameState;
  final Bird bird;
  final List<Pipe> pipes;
  final List<Particle> particles;
  final GameStats stats;

  GameControllerState({
    required this.gameState,
    required this.bird,
    required this.pipes,
    required this.particles,
    required this.stats,
  });

  factory GameControllerState.initial() {
    return GameControllerState(
      gameState: GameState.ready,
      bird: Bird(),
      pipes: [],
      particles: [],
      stats: GameStats(),
    );
  }

  GameControllerState copyWith({
    GameState? gameState,
    Bird? bird,
    List<Pipe>? pipes,
    List<Particle>? particles,
    GameStats? stats,
  }) {
    return GameControllerState(
      gameState: gameState ?? this.gameState,
      bird: bird ?? this.bird,
      pipes: pipes ?? this.pipes,
      particles: particles ?? this.particles,
      stats: stats ?? this.stats,
    );
  }
}

/// 게임 컨트롤러 프로바이더
final gameControllerProvider =
    StateNotifierProvider<GameController, GameControllerState>(
  (ref) => GameController(),
);
