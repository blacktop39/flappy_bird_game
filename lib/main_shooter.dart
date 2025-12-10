/// Shooter Game - Professional Flutter Game
///
/// 아키텍처:
/// - MVC 패턴 적용
/// - Riverpod을 통한 상태 관리
/// - 관심사 분리 (모델, 뷰, 컨트롤러)
/// - 성능 최적화
///
/// 주요 기능:
/// - 360도 슈팅 시스템
/// - 웨이브 기반 적 생성
/// - 영구 저장 (최고 점수)
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/storage_service.dart';
import 'providers/shooter_provider.dart';
import 'widgets/shooter_widgets.dart';
import 'constants/game_constants.dart';
import 'models/shooter_models.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 스토리지 서비스 초기화
  await StorageService.instance.init();

  // 앱 실행
  runApp(
    const ProviderScope(
      child: ShooterGameApp(),
    ),
  );
}

/// 앱 루트 위젯
class ShooterGameApp extends StatelessWidget {
  const ShooterGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shooter Game - Professional Edition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const ShooterGame(),
    );
  }
}

/// 메인 게임 화면
class ShooterGame extends ConsumerStatefulWidget {
  const ShooterGame({Key? key}) : super(key: key);

  @override
  ConsumerState<ShooterGame> createState() => _ShooterGameState();
}

class _ShooterGameState extends ConsumerState<ShooterGame> {
  // 포커스 노드 (키보드 입력용)
  final FocusNode _focusNode = FocusNode();

  // 키 입력 상태
  final Set<LogicalKeyboardKey> _pressedKeys = {};

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    // 키보드 이동 업데이트 루프
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 16));
      if (mounted) {
        _handleMovement();
      }
      return mounted;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// 키보드 입력 처리
  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);

      // ESC: 일시정지
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        ref.read(shooterGameControllerProvider.notifier).togglePause();
      }
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }
  }

  /// 이동 처리
  void _handleMovement() {
    if (_pressedKeys.isEmpty) return;

    double dx = 0;
    double dy = 0;

    if (_pressedKeys.contains(LogicalKeyboardKey.keyW) ||
        _pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      dy = -1;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyS) ||
        _pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      dy = 1;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyA) ||
        _pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      dx = -1;
    }
    if (_pressedKeys.contains(LogicalKeyboardKey.keyD) ||
        _pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      dx = 1;
    }

    if (dx != 0 || dy != 0) {
      ref.read(shooterGameControllerProvider.notifier).movePlayer(dx, dy);
    }
  }

  /// 마우스 클릭 처리 (발사)
  void _handleTap(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.globalPosition);

    // 게임 영역 기준으로 변환
    final screenWidth = box.size.width;
    final screenHeight = box.size.height;
    final gameX = (offset.dx - (screenWidth - GameAreaConstants.width) / 2);
    final gameY = (offset.dy - (screenHeight - GameAreaConstants.height) / 2);

    ref.read(shooterGameControllerProvider.notifier).shoot(gameX, gameY);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(shooterGameControllerProvider);

    return Scaffold(
      backgroundColor: GameColors.bgGradientStart,
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _handleKeyPress,
        child: GestureDetector(
          onTapDown: _handleTap,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // 배경
              const Positioned.fill(
                child: ShooterBackground(),
              ),

              // 게임 영역
              Center(
                child: SizedBox(
                  width: GameAreaConstants.width,
                  height: GameAreaConstants.height,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // 적들
                      ...gameState.enemies.map(
                        (enemy) => EnemyWidget(enemy: enemy),
                      ),

                      // 총알들
                      ...gameState.bullets.map(
                        (bullet) => BulletWidget(bullet: bullet),
                      ),

                      // 플레이어
                      PlayerWidget(player: gameState.player),

                      // HUD
                      if (gameState.gameState == GameState.playing)
                        GameHUD(
                          score: gameState.stats.score,
                          health: gameState.player.health,
                          wave: gameState.stats.wave,
                        ),

                      // 게임 오버 / 시작 화면
                      GameOverlay(
                        gameState: gameState.gameState,
                        score: gameState.stats.score,
                        bestScore: gameState.stats.bestScore,
                        wave: gameState.stats.wave,
                        onStart: () => ref
                            .read(shooterGameControllerProvider.notifier)
                            .startGame(),
                        onRestart: () => ref
                            .read(shooterGameControllerProvider.notifier)
                            .restartGame(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
