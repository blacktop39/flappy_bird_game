import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(FlappyBirdApp());
}

class FlappyBirdApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flappy Bird Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlappyBirdGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FlappyBirdGame extends StatefulWidget {
  @override
  _FlappyBirdGameState createState() => _FlappyBirdGameState();
}

class _FlappyBirdGameState extends State<FlappyBirdGame>
    with TickerProviderStateMixin {
  // 게임 상태
  bool gameStarted = false;
  bool gameOver = false;
  int score = 0;
  int bestScore = 0;

  // 새 위치 및 물리 (쉽게 조정)
  double birdY = 0;
  double birdVelocity = 0;
  double gravity = 0.6;  // 중력 감소 (0.8 → 0.6)
  double jumpStrength = -10;  // 점프력 감소 (-12 → -10)

  // 파이프 (쉽게 조정)
  List<Pipe> pipes = [];
  double pipeSpeed = 2.5;  // 속도 감소 (3 → 2.5)
  Timer? gameTimer;
  Timer? pipeTimer;

  // 애니메이션
  late AnimationController birdAnimationController;
  late Animation<double> birdAnimation;

  @override
  void initState() {
    super.initState();
    birdAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    birdAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: birdAnimationController, curve: Curves.easeInOut),
    );
    birdAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    pipeTimer?.cancel();
    birdAnimationController.dispose();
    super.dispose();
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      gameOver = false;
      score = 0;
      birdY = 0;
      birdVelocity = 0;
      pipes.clear();
    });

    // 게임 루프 (60 FPS)
    gameTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (!gameOver) {
        updateGame();
      }
    });

    // 파이프 생성 (2초마다로 변경 - 더 여유롭게)
    pipeTimer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
      if (!gameOver) {
        addPipe();
      }
    });
  }

  void updateGame() {
    setState(() {
      // 새 물리 계산
      birdVelocity += gravity;
      birdY += birdVelocity;

      // 파이프 이동
      for (int i = 0; i < pipes.length; i++) {
        pipes[i].x -= pipeSpeed;

        // 점수 증가 (파이프를 통과할 때)
        if (!pipes[i].scored && pipes[i].x < -50) {
          pipes[i].scored = true;
          score++;
        }
      }

      // 화면 밖 파이프 제거
      pipes.removeWhere((pipe) => pipe.x < -100);

      // 충돌 검사
      checkCollision();
    });
  }

  void addPipe() {
    double gapHeight = 200;  // 간격 넓히기 (160 → 200)
    double minHeight = 80;   // 최소 높이 줄이기 (100 → 80)
    double maxHeight = 250;  // 최대 높이 줄이기 (300 → 250)
    double pipeHeight = minHeight + Random().nextDouble() * (maxHeight - minHeight);
    
    pipes.add(Pipe(
      x: 400,
      topHeight: pipeHeight,
      bottomHeight: 600 - pipeHeight - gapHeight,
    ));
  }

  void jump() {
    if (gameOver) {
      restartGame();
      return;
    }

    if (!gameStarted) {
      startGame();
      return;
    }

    setState(() {
      birdVelocity = jumpStrength;
    });
  }

  void checkCollision() {
    // 바닥이나 천장 충돌 (여유 공간 증가)
    if (birdY > 280 || birdY < -280) {
      endGame();
      return;
    }

    // 파이프 충돌 (충돌 감지를 더 관대하게)
    for (Pipe pipe in pipes) {
      if (pipe.x > -70 && pipe.x < 70) {  // 충돌 범위 축소
        if (birdY < -300 + pipe.topHeight + 30 || birdY > 300 - pipe.bottomHeight - 30) {  // 여유 공간 증가 (20 → 30)
          endGame();
          return;
        }
      }
    }
  }

  void endGame() {
    setState(() {
      gameOver = true;
      if (score > bestScore) {
        bestScore = score;
      }
    });

    gameTimer?.cancel();
    pipeTimer?.cancel();
    birdAnimationController.stop();
  }

  void restartGame() {
    setState(() {
      gameStarted = false;
      gameOver = false;
      score = 0;
      birdY = 0;
      birdVelocity = 0;
      pipes.clear();
    });

    gameTimer?.cancel();
    pipeTimer?.cancel();
    birdAnimationController.repeat(reverse: true);
  }

  String _getScoreMessage(int score) {
    if (score >= 50) return "🏆 전설적이에요! 마스터급!";
    if (score >= 30) return "🌟 대단해요! 전문가네요!";
    if (score >= 20) return "🎯 훌륭해요! 고수에요!";
    if (score >= 15) return "👏 멋져요! 실력자네요!";
    if (score >= 10) return "🎉 좋아요! 꽤 잘하시네요!";
    if (score >= 5) return "😊 괜찮아요! 연습하면 더 잘할 수 있어요!";
    if (score >= 1) return "🐦 첫 점수! 좋은 시작이에요!";
    return "💪 다시 도전해보세요! 할 수 있어요!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF70C5CE),
      body: RawKeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.space ||
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.arrowUp) {
              jump();
            }
          }
        },
        child: GestureDetector(
          onTap: jump,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF87CEEB),
                  Color(0xFF98FB98),
                ],
              ),
            ),
            child: Stack(
              children: [
                // 구름들 (배경)
                Positioned(
                  top: 100,
                  left: 50,
                  child: CloudWidget(),
                ),
                Positioned(
                  top: 150,
                  right: 80,
                  child: CloudWidget(),
                ),
                Positioned(
                  top: 200,
                  left: 150,
                  child: CloudWidget(),
                ),

                // 게임 영역
                Center(
                  child: Container(
                    width: 400,
                    height: 600,
                    child: Stack(
                      children: [
                        // 파이프들
                        ...pipes.map((pipe) => PipeWidget(pipe: pipe)).toList(),
                        
                        // 새
                        AnimatedBuilder(
                          animation: birdAnimation,
                          builder: (context, child) {
                            return Positioned(
                              left: 150,
                              top: 300 + birdY - 20,
                              child: Transform.rotate(
                                angle: birdVelocity * 0.03,
                                child: Container(
                                  width: 40,
                                  height: 30,
                                  child: Stack(
                                    children: [
                                      // 새 몸체
                                      Positioned(
                                        left: 5,
                                        top: 5,
                                        child: Container(
                                          width: 30,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade600,
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(color: Colors.orange, width: 2),
                                          ),
                                        ),
                                      ),
                                      // 눈
                                      Positioned(
                                        left: 20,
                                        top: 8,
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      // 부리
                                      Positioned(
                                        left: 28,
                                        top: 12,
                                        child: Container(
                                          width: 0,
                                          height: 0,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.orange,
                                                width: 6,
                                                style: BorderStyle.solid,
                                              ),
                                              left: BorderSide(
                                                color: Colors.transparent,
                                                width: 8,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // 점수 표시
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.orange, width: 2),
                      ),
                      child: Text(
                        'Score: $score',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ),
                ),

                // 시작/게임오버 화면
                if (!gameStarted || gameOver)
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange, width: 3),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gameOver ? '🎮 Game Over!' : '🐦 Flappy Bird',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade800,
                              ),
                            ),
                            SizedBox(height: 20),
                            if (gameOver) ...[
                              Text(
                                '점수: $score',
                                style: TextStyle(fontSize: 24, color: Colors.black87),
                              ),
                              Text(
                                '최고 점수: $bestScore',
                                style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _getScoreMessage(score),
                                style: TextStyle(fontSize: 16, color: Colors.blue.shade600, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                            ],
                            ElevatedButton(
                              onPressed: gameOver ? restartGame : startGame,
                              child: Text(
                                gameOver ? '🔄 다시 시작' : '🚀 게임 시작',
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              '🖱️ 클릭하거나 스페이스바를 눌러 날기',
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Pipe {
  double x;
  double topHeight;
  double bottomHeight;
  bool scored;

  Pipe({
    required this.x,
    required this.topHeight,
    required this.bottomHeight,
    this.scored = false,
  });
}

class PipeWidget extends StatelessWidget {
  final Pipe pipe;

  const PipeWidget({Key? key, required this.pipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 위쪽 파이프
        Positioned(
          left: pipe.x,
          top: 0,
          child: Container(
            width: 60,
            height: pipe.topHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.green.shade900, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // 위쪽 파이프 캡
        Positioned(
          left: pipe.x - 5,
          top: pipe.topHeight - 20,
          child: Container(
            width: 70,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.green.shade900, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        // 아래쪽 파이프
        Positioned(
          left: pipe.x,
          bottom: 0,
          child: Container(
            width: 60,
            height: pipe.bottomHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.green.shade900, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        // 아래쪽 파이프 캡
        Positioned(
          left: pipe.x - 5,
          bottom: pipe.bottomHeight - 20,
          child: Container(
            width: 70,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.green.shade900, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class CloudWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 30,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 15,
            top: 5,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}