/// Flappy Bird Game - Professional Flutter Game
///
/// 아키텍처:
/// - MVC 패턴 적용
/// - Riverpod을 통한 상태 관리
/// - 관심사 분리 (모델, 뷰, 컨트롤러)
/// - 성능 최적화 (RepaintBoundary, CustomPainter)
///
/// 주요 기능:
/// - 물리 기반 시뮬레이션
/// - 파티클 효과
/// - 영구 저장 (최고 점수)
/// - 반응형 디자인
/// - 접근성 지원
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/storage_service.dart';
import 'providers/game_provider.dart';
import 'widgets/game_widgets.dart';
import 'constants/game_constants.dart';
import 'models/game_models.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 스토리지 서비스 초기화
  await StorageService.instance.init();

  // 앱 실행
  runApp(
    const ProviderScope(
      child: FlappyBirdApp(),
    ),
  );
}

/// 앱 루트 위젯
class FlappyBirdApp extends StatelessWidget {
  const FlappyBirdApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird - Professional Edition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const FlappyBirdGame(),
    );
  }
}

/// 메인 게임 화면
class FlappyBirdGame extends ConsumerStatefulWidget {
  const FlappyBirdGame({Key? key}) : super(key: key);

  @override
  ConsumerState<FlappyBirdGame> createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends ConsumerState<FlappyBirdGame>
    with TickerProviderStateMixin {
  // 애니메이션 컨트롤러
  late AnimationController _wingAnimationController;
  late Animation<double> _wingAnimation;

  // 포커스 노드 (키보드 입력용)
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _focusNode.requestFocus();
  }

  /// 애니메이션 초기화
  void _initializeAnimations() {
    _wingAnimationController = AnimationController(
      duration: const Duration(milliseconds: BirdConstants.wingFlapDuration),
      vsync: this,
    );

    _wingAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _wingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _wingAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _wingAnimationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// 키보드 입력 처리
  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _jump();
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(gameControllerProvider.notifier).togglePause();
      }
    }
  }

  /// 점프 액션
  void _jump() {
    ref.read(gameControllerProvider.notifier).jump();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: GameColors.skyGradientStart,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyPress,
        child: GestureDetector(
          onTap: _jump,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // 배경
              const Positioned.fill(
                child: BackgroundWidget(),
              ),

              // 게임 영역
              Center(
                child: SizedBox(
                  width: GameAreaConstants.width,
                  height: GameAreaConstants.height,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 파이프들
                      ...gameState.pipes.map(
                        (pipe) => PipeWidget(pipe: pipe),
                      ),

                      // 파티클 효과
                      ...gameState.particles.map(
                        (particle) => ParticleWidget(particle: particle),
                      ),

                      // 새
                      AnimatedBuilder(
                        animation: _wingAnimation,
                        builder: (context, child) {
                          return BirdWidget(
                            bird: gameState.bird,
                            wingAnimation: _wingAnimation,
                          );
                        },
                      ),

                      // 점수 표시
                      if (gameState.gameState == GameState.playing)
                        ScoreDisplay(
                          score: gameState.stats.score,
                          bestScore: gameState.stats.bestScore,
                        ),

                      // 게임 오버 / 시작 화면
                      GameOverlay(
                        gameState: gameState.gameState,
                        score: gameState.stats.score,
                        bestScore: gameState.stats.bestScore,
                        onStart: () => ref
                            .read(gameControllerProvider.notifier)
                            .startGame(),
                        onRestart: () => ref
                            .read(gameControllerProvider.notifier)
                            .restartGame(),
                      ),

                      // 일시정지 화면
                      if (gameState.gameState == GameState.paused)
                        _buildPausedOverlay(),
                    ],
                  ),
                ),
              ),

              // 디버그 정보 (개발 모드)
              if (const bool.fromEnvironment('DEBUG_MODE', defaultValue: false))
                _buildDebugInfo(gameState),
            ],
          ),
        ),
      ),
    );
  }

  /// 일시정지 화면
  Widget _buildPausedOverlay() {
    return Container(
      color: GameColors.modalOverlay,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: GameColors.modalBackground,
            borderRadius: BorderRadius.circular(UIConstants.modalBorderRadius),
            border: Border.all(
              color: GameColors.birdAccent,
              width: 4,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '⏸️ 일시정지',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    ref.read(gameControllerProvider.notifier).togglePause(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.buttonPrimary,
                  foregroundColor: GameColors.buttonText,
                  padding: UIConstants.buttonPadding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  '▶️ 계속하기',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 디버그 정보 표시
  Widget _buildDebugInfo(GameControllerState gameState) {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bird Y: ${gameState.bird.y.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Velocity: ${gameState.bird.velocity.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Pipes: ${gameState.pipes.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Particles: ${gameState.particles.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              'Jumps: ${gameState.stats.totalJumps}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
