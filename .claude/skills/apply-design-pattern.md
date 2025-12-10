---
name: apply-design-pattern
description: 특정 디자인 패턴을 코드에 적용합니다
arguments:
  - name: pattern
    description: 적용할 패턴 (singleton/factory/strategy/observer/builder 등)
    required: true
  - name: target_path
    description: 패턴을 적용할 대상 파일/디렉토리
    required: true
---

# 디자인 패턴 적용

{{target_path}}에 {{pattern}} 패턴을 적용합니다.

## 패턴 선택: {{pattern}}

{{#if pattern === "singleton"}}
### Singleton 패턴

**사용 시기**:
- 앱 전체에서 단 하나의 인스턴스만 필요한 경우
- 예: StorageService, AudioManager, Logger

**Flutter/Dart 구현**:
```dart
class ServiceName {
  // Private 생성자
  ServiceName._();

  // Static final 인스턴스
  static final ServiceName instance = ServiceName._();

  // 또는 Lazy initialization
  static ServiceName? _instance;
  static ServiceName get instance {
    _instance ??= ServiceName._();
    return _instance!;
  }
}
```

**주의사항**:
- 테스트가 어려워질 수 있음
- Riverpod Provider로 대체 고려
{{/if}}

{{#if pattern === "factory"}}
### Factory 패턴

**사용 시기**:
- 객체 생성 로직이 복잡한 경우
- 조건에 따라 다른 타입의 객체를 생성해야 하는 경우

**구현**:
```dart
abstract class Enemy {
  factory Enemy.create(String type) {
    switch (type) {
      case 'basic':
        return BasicEnemy();
      case 'fast':
        return FastEnemy();
      case 'boss':
        return BossEnemy();
      default:
        throw ArgumentError('Unknown enemy type: $type');
    }
  }
}

class BasicEnemy implements Enemy {
  // ...
}
```

**또는 Named Constructor Factory**:
```dart
class Enemy {
  final double speed;
  final int health;

  Enemy._({required this.speed, required this.health});

  factory Enemy.basic() => Enemy._(speed: 2.0, health: 1);
  factory Enemy.fast() => Enemy._(speed: 5.0, health: 1);
  factory Enemy.tank() => Enemy._(speed: 1.0, health: 5);
}
```
{{/if}}

{{#if pattern === "strategy"}}
### Strategy 패턴

**사용 시기**:
- 알고리즘/동작을 런타임에 선택해야 하는 경우
- 여러 if-else나 switch를 대체하고 싶은 경우

**구현**:
```dart
// Strategy 인터페이스
abstract class MovementStrategy {
  void move(Enemy enemy);
}

// 구체적인 전략들
class LinearMovement implements MovementStrategy {
  @override
  void move(Enemy enemy) {
    // 직선 이동
  }
}

class ZigzagMovement implements MovementStrategy {
  @override
  void move(Enemy enemy) {
    // 지그재그 이동
  }
}

// 사용
class Enemy {
  MovementStrategy strategy;

  Enemy(this.strategy);

  void update() {
    strategy.move(this);
  }
}
```
{{/if}}

{{#if pattern === "observer"}}
### Observer 패턴 (Riverpod)

**사용 시기**:
- 상태 변화를 여러 위젯에 알려야 하는 경우
- Flutter에서는 Riverpod이 이 패턴을 구현

**구현**:
```dart
// State Provider
final gameStateProvider = StateNotifierProvider<GameController, GameState>(
  (ref) => GameController(),
);

// Observer (위젯)
class GameWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);

    return Text('Score: ${gameState.score}');
  }
}
```
{{/if}}

{{#if pattern === "builder"}}
### Builder 패턴

**사용 시기**:
- 많은 선택적 파라미터를 가진 객체를 생성할 때
- 객체 생성 과정이 복잡한 경우

**구현**:
```dart
class GameConfigBuilder {
  double? _difficulty;
  int? _maxEnemies;
  bool? _soundEnabled;

  GameConfigBuilder difficulty(double value) {
    _difficulty = value;
    return this;
  }

  GameConfigBuilder maxEnemies(int value) {
    _maxEnemies = value;
    return this;
  }

  GameConfigBuilder sound(bool enabled) {
    _soundEnabled = enabled;
    return this;
  }

  GameConfig build() {
    return GameConfig(
      difficulty: _difficulty ?? 1.0,
      maxEnemies: _maxEnemies ?? 10,
      soundEnabled: _soundEnabled ?? true,
    );
  }
}

// 사용
final config = GameConfigBuilder()
  .difficulty(2.0)
  .maxEnemies(20)
  .sound(false)
  .build();
```

**또는 Named Parameters (Dart스러운 방식)**:
```dart
class GameConfig {
  final double difficulty;
  final int maxEnemies;
  final bool soundEnabled;

  const GameConfig({
    this.difficulty = 1.0,
    this.maxEnemies = 10,
    this.soundEnabled = true,
  });
}
```
{{/if}}

{{#if pattern === "command"}}
### Command 패턴

**사용 시기**:
- 실행 취소(Undo) 기능이 필요한 경우
- 명령을 큐에 저장하거나 로깅해야 하는 경우

**구현**:
```dart
abstract class Command {
  void execute();
  void undo();
}

class MoveCommand implements Command {
  final Player player;
  final double dx, dy;
  double? _previousX, _previousY;

  MoveCommand(this.player, this.dx, this.dy);

  @override
  void execute() {
    _previousX = player.x;
    _previousY = player.y;
    player.move(dx, dy);
  }

  @override
  void undo() {
    player.x = _previousX!;
    player.y = _previousY!;
  }
}
```
{{/if}}

{{#if pattern === "state"}}
### State 패턴

**사용 시기**:
- 객체의 상태에 따라 동작이 달라지는 경우
- 상태 전환 로직이 복잡한 경우

**구현**:
```dart
abstract class GameState {
  void handleInput(GameContext context);
  void update(GameContext context);
}

class PlayingState implements GameState {
  @override
  void handleInput(GameContext context) {
    // 게임 중 입력 처리
  }

  @override
  void update(GameContext context) {
    // 게임 로직 업데이트
  }
}

class PausedState implements GameState {
  @override
  void handleInput(GameContext context) {
    // 일시정지 중 입력 처리
  }

  @override
  void update(GameContext context) {
    // 일시정지 상태 유지
  }
}

class GameContext {
  GameState _state = PlayingState();

  void setState(GameState state) {
    _state = state;
  }

  void handleInput() {
    _state.handleInput(this);
  }

  void update() {
    _state.update(this);
  }
}
```
{{/if}}

## 적용 프로세스

1. **현재 코드 분석**
   - {{target_path}} 읽기
   - 패턴 적용 전 구조 파악

2. **패턴 적용 계획**
   - 어떤 클래스/함수를 변경할지 결정
   - 새로 생성할 파일 목록

3. **단계별 리팩토링**
   - 기존 코드를 패턴에 맞게 변경
   - 새 클래스/인터페이스 생성

4. **테스트 및 검증**
   - 기능이 동일하게 작동하는지 확인
   - flutter analyze 실행

## 완료 리포트

```
## ✅ {{pattern}} 패턴 적용 완료

### 변경된 파일
- [파일 목록]

### 주요 변경사항
- Before: [기존 구조 설명]
- After: [새 구조 설명]

### 개선 효과
- 유지보수성: [설명]
- 확장성: [설명]
- 테스트 용이성: [설명]

### 사용 예시
[코드 예시]
```
