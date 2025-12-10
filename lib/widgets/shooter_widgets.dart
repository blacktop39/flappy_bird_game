/// 슈팅 게임 UI 위젯 컴포넌트들
/// 재사용 가능하고 성능 최적화된 위젯들
library;

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/shooter_models.dart';
import '../constants/game_constants.dart';

/// 플레이어 위젯
class PlayerWidget extends StatelessWidget {
  final Player player;

  const PlayerWidget({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: player.x - PlayerConstants.size / 2,
      top: player.y - PlayerConstants.size / 2,
      child: Container(
        width: PlayerConstants.size,
        height: PlayerConstants.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: GameColors.player,
          border: Border.all(
            color: GameColors.playerBorder,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: GameColors.player.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// 적 위젯
class EnemyWidget extends StatelessWidget {
  final Enemy enemy;

  const EnemyWidget({
    Key? key,
    required this.enemy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: enemy.x - EnemyConstants.size / 2,
      top: enemy.y - EnemyConstants.size / 2,
      child: Container(
        width: EnemyConstants.size,
        height: EnemyConstants.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: GameColors.enemy,
          border: Border.all(
            color: GameColors.enemyBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: GameColors.enemy.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/// 총알 위젯
class BulletWidget extends StatelessWidget {
  final Bullet bullet;

  const BulletWidget({
    Key? key,
    required this.bullet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: bullet.x - BulletConstants.size / 2,
      top: bullet.y - BulletConstants.size / 2,
      child: Container(
        width: BulletConstants.size,
        height: BulletConstants.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: GameColors.bullet,
          boxShadow: [
            BoxShadow(
              color: GameColors.bulletGlow.withOpacity(0.8),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// HUD (점수, 체력 등)
class GameHUD extends StatelessWidget {
  final int score;
  final int health;
  final int wave;

  const GameHUD({
    Key? key,
    required this.score,
    required this.health,
    required this.wave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 점수
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameColors.player, width: 2),
            ),
            child: Text(
              'Score: $score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 웨이브
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameColors.bullet, width: 2),
            ),
            child: Text(
              'Wave $wave',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 체력
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: GameColors.enemy, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$health',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 게임 오버 / 시작 화면
class GameOverlay extends StatelessWidget {
  final GameState gameState;
  final int score;
  final int bestScore;
  final int wave;
  final VoidCallback onStart;
  final VoidCallback onRestart;

  const GameOverlay({
    Key? key,
    required this.gameState,
    required this.score,
    required this.bestScore,
    required this.wave,
    required this.onStart,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gameState == GameState.playing) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1a1a2e),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: GameColors.player,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: GameColors.player.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 타이틀
              Text(
                gameState == GameState.gameOver ? '💀 Game Over!' : '🎮 Shooter Game',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: gameState == GameState.gameOver
                      ? GameColors.enemy
                      : GameColors.player,
                ),
              ),
              const SizedBox(height: 24),

              // 점수 (게임오버일 때만)
              if (gameState == GameState.gameOver) ...[
                _buildStatRow('Score', score.toString(), GameColors.player),
                const SizedBox(height: 12),
                _buildStatRow('Wave', wave.toString(), GameColors.bullet),
                const SizedBox(height: 12),
                _buildStatRow('Best', bestScore.toString(), GameColors.enemy),
                const SizedBox(height: 12),
                Text(
                  _getScoreMessage(score),
                  style: TextStyle(
                    fontSize: 16,
                    color: GameColors.bullet,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ] else ...[
                const Text(
                  '사방에서 적이 몰려옵니다!\n화면을 클릭해서 적을 물리치세요!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],

              // 버튼
              ElevatedButton(
                onPressed: gameState == GameState.gameOver ? onRestart : onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gameState == GameState.gameOver
                      ? GameColors.enemy
                      : GameColors.player,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                ),
                child: Text(
                  gameState == GameState.gameOver ? '🔄 다시 시작' : '🚀 게임 시작',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 조작법
              const Text(
                '🖱️ 클릭: 발사 | ⌨️ WASD: 이동 | ESC: 일시정지',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 500) return "🏆 전설! 당신은 마스터입니다!";
    if (score >= 300) return "🌟 놀라워요! 고수시네요!";
    if (score >= 200) return "🎯 훌륭해요! 실력자입니다!";
    if (score >= 100) return "👏 멋져요! 잘하고 있어요!";
    if (score >= 50) return "🎉 좋아요! 계속 도전하세요!";
    if (score >= 10) return "😊 괜찮아요! 조금만 더!";
    return "💪 다시 도전해보세요!";
  }
}

/// 배경 위젯
class ShooterBackground extends StatelessWidget {
  const ShooterBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            GameColors.bgGradientStart,
            GameColors.bgGradientEnd,
          ],
        ),
      ),
      child: CustomPaint(
        painter: _StarsPainter(),
        size: Size.infinite,
      ),
    );
  }
}

/// 별 그리기 (배경)
class _StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final random = Random(42); // 고정된 seed로 일관된 별 위치

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 0.5;

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
