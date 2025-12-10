/// 게임 UI 위젯 컴포넌트들
/// 재사용 가능하고 성능 최적화된 위젯들
library;

import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../constants/game_constants.dart';

/// 새 위젯 (성능 최적화)
class BirdWidget extends StatelessWidget {
  final Bird bird;
  final Animation<double> wingAnimation;

  const BirdWidget({
    Key? key,
    required this.bird,
    required this.wingAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: BirdConstants.xPosition,
      top: GameAreaConstants.halfHeight + bird.y - BirdConstants.height / 2,
      child: Transform.rotate(
        angle: bird.getRotation(),
        child: SizedBox(
          width: BirdConstants.width,
          height: BirdConstants.height,
          child: CustomPaint(
            painter: _BirdPainter(wingAnimation.value),
          ),
        ),
      ),
    );
  }
}

/// 새 그리기 (CustomPainter로 성능 최적화)
class _BirdPainter extends CustomPainter {
  final double wingPhase;

  _BirdPainter(this.wingPhase);

  @override
  void paint(Canvas canvas, Size size) {
    // 몸통
    final bodyPaint = Paint()
      ..color = GameColors.birdBody
      ..style = PaintingStyle.fill;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(5, 5, 30, 20),
      const Radius.circular(15),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // 테두리
    final borderPaint = Paint()
      ..color = GameColors.birdAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(bodyRect, borderPaint);

    // 눈
    final eyePaint = Paint()
      ..color = GameColors.birdEye
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(24, 12), 4, eyePaint);

    // 눈 하이라이트
    final eyeHighlightPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(25, 11), 2, eyeHighlightPaint);

    // 부리
    final beakPath = Path()
      ..moveTo(32, 15)
      ..lineTo(40, 13)
      ..lineTo(32, 11)
      ..close();
    final beakPaint = Paint()
      ..color = GameColors.birdAccent
      ..style = PaintingStyle.fill;
    canvas.drawPath(beakPath, beakPaint);

    // 날개 (애니메이션)
    final wingY = 18 + wingPhase * 4;
    final wingPath = Path()
      ..moveTo(15, wingY)
      ..quadraticBezierTo(10, wingY - 5, 5, wingY)
      ..quadraticBezierTo(10, wingY + 5, 15, wingY)
      ..close();
    final wingPaint = Paint()
      ..color = GameColors.birdBody.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawPath(wingPath, wingPaint);
  }

  @override
  bool shouldRepaint(_BirdPainter oldDelegate) {
    return oldDelegate.wingPhase != wingPhase;
  }
}

/// 파이프 위젯 (RepaintBoundary로 최적화)
class PipeWidget extends StatelessWidget {
  final Pipe pipe;

  const PipeWidget({
    Key? key,
    required this.pipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // 위쪽 파이프
          _buildPipeSegment(
            left: pipe.x,
            top: 0,
            height: pipe.topHeight,
            isTop: true,
          ),
          // 아래쪽 파이프
          _buildPipeSegment(
            left: pipe.x,
            bottom: 0,
            height: pipe.bottomHeight,
            isTop: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPipeSegment({
    required double left,
    double? top,
    double? bottom,
    required double height,
    required bool isTop,
  }) {
    return Positioned(
      left: left,
      top: top,
      bottom: bottom,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isTop) ...[
            // 파이프 몸통
            Container(
              width: PipeConstants.width,
              height: height - PipeConstants.capHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GameColors.pipeLightGreen,
                    GameColors.pipeDarkGreen,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(
                  color: GameColors.pipeBorder,
                  width: 3,
                ),
              ),
            ),
            // 파이프 캡
            Container(
              width: PipeConstants.width + PipeConstants.capExtraWidth * 2,
              height: PipeConstants.capHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GameColors.pipeLightGreen,
                    GameColors.pipeDarkGreen,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(
                  color: GameColors.pipeBorder,
                  width: 3,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(5),
                ),
              ),
            ),
          ] else ...[
            // 파이프 캡
            Container(
              width: PipeConstants.width + PipeConstants.capExtraWidth * 2,
              height: PipeConstants.capHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GameColors.pipeLightGreen,
                    GameColors.pipeDarkGreen,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(
                  color: GameColors.pipeBorder,
                  width: 3,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(5),
                ),
              ),
            ),
            // 파이프 몸통
            Container(
              width: PipeConstants.width,
              height: height - PipeConstants.capHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    GameColors.pipeLightGreen,
                    GameColors.pipeDarkGreen,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                border: Border.all(
                  color: GameColors.pipeBorder,
                  width: 3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 파티클 위젯
class ParticleWidget extends StatelessWidget {
  final Particle particle;

  const ParticleWidget({
    Key? key,
    required this.particle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: particle.x,
      top: particle.y,
      child: Opacity(
        opacity: particle.getOpacity(),
        child: Container(
          width: particle.size,
          height: particle.size,
          decoration: BoxDecoration(
            color: particle.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: particle.color.withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 구름 위젯
class CloudWidget extends StatelessWidget {
  const CloudWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: 80,
        height: 40,
        child: CustomPaint(
          painter: _CloudPainter(),
        ),
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = GameColors.cloudColor
      ..style = PaintingStyle.fill;

    // 구름의 여러 원들
    canvas.drawCircle(const Offset(15, 25), 12, paint);
    canvas.drawCircle(const Offset(30, 20), 15, paint);
    canvas.drawCircle(const Offset(50, 23), 13, paint);
    canvas.drawCircle(const Offset(40, 28), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 점수 표시 위젯
class ScoreDisplay extends StatelessWidget {
  final int score;
  final int bestScore;

  const ScoreDisplay({
    Key? key,
    required this.score,
    required this.bestScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: GameColors.scoreBackground,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: GameColors.birdAccent,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: GameColors.shadowColor,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: UIConstants.scoreFontSize,
                fontWeight: FontWeight.bold,
                color: GameColors.scoreText,
                shadows: const [
                  Shadow(
                    color: Colors.white,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          if (bestScore > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Best: $bestScore',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
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
  final VoidCallback onStart;
  final VoidCallback onRestart;

  const GameOverlay({
    Key? key,
    required this.gameState,
    required this.score,
    required this.bestScore,
    required this.onStart,
    required this.onRestart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gameState == GameState.playing) {
      return const SizedBox.shrink();
    }

    return Container(
      color: GameColors.modalOverlay,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: GameColors.modalBackground,
            borderRadius: BorderRadius.circular(UIConstants.modalBorderRadius),
            border: Border.all(
              color: GameColors.birdAccent,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: GameColors.shadowColor,
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
                gameState == GameState.gameOver ? '🎮 Game Over!' : '🐦 Flappy Bird',
                style: TextStyle(
                  fontSize: UIConstants.gameOverTitleSize,
                  fontWeight: FontWeight.bold,
                  color: GameColors.birdAccent,
                ),
              ),
              const SizedBox(height: 24),

              // 점수 (게임오버일 때만)
              if (gameState == GameState.gameOver) ...[
                _buildScoreRow('Score', score, GameColors.scoreText),
                const SizedBox(height: 12),
                _buildScoreRow('Best', bestScore, Colors.red),
                const SizedBox(height: 12),
                Text(
                  _getScoreMessage(score),
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],

              // 버튼
              ElevatedButton(
                onPressed: gameState == GameState.gameOver ? onRestart : onStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.buttonPrimary,
                  foregroundColor: GameColors.buttonText,
                  padding: UIConstants.buttonPadding,
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
              Text(
                '🖱️ 클릭 | ⌨️ 스페이스바 | 📱 터치',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, int value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: UIConstants.gameOverScoreSize,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          '$value',
          style: TextStyle(
            fontSize: UIConstants.gameOverScoreSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 100) return "🏆 전설! 당신은 마스터입니다!";
    if (score >= 50) return "🌟 놀라워요! 전문가 수준이에요!";
    if (score >= 30) return "🎯 훌륭해요! 고수시네요!";
    if (score >= 20) return "👏 멋져요! 실력자입니다!";
    if (score >= 10) return "🎉 좋아요! 잘하고 있어요!";
    if (score >= 5) return "😊 괜찮아요! 계속 연습하세요!";
    if (score >= 1) return "🐦 좋은 시작이에요!";
    return "💪 다시 도전해보세요!";
  }
}

/// 배경 위젯
class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            GameColors.skyGradientStart,
            GameColors.skyGradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: const [
          Positioned(top: 80, left: 60, child: CloudWidget()),
          Positioned(top: 140, right: 100, child: CloudWidget()),
          Positioned(top: 220, left: 180, child: CloudWidget()),
          Positioned(top: 300, right: 50, child: CloudWidget()),
        ],
      ),
    );
  }
}
