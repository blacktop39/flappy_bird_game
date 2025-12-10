# 🏗️ Flappy Bird - Professional 아키텍처 문서

## 📋 목차
- [아키텍처 개요](#아키텍처-개요)
- [프로젝트 구조](#프로젝트-구조)
- [핵심 설계 패턴](#핵심-설계-패턴)
- [성능 최적화](#성능-최적화)
- [확장 가능성](#확장-가능성)

## 🎯 아키텍처 개요

### 설계 원칙
1. **관심사 분리 (Separation of Concerns)**
   - 모델, 뷰, 컨트롤러의 명확한 분리
   - 각 레이어가 독립적으로 테스트 가능

2. **단일 책임 원칙 (Single Responsibility)**
   - 각 클래스와 모듈이 하나의 책임만 가짐
   - 유지보수와 확장이 용이

3. **의존성 역전 (Dependency Inversion)**
   - 추상화에 의존, 구체적인 구현에 의존하지 않음
   - Riverpod을 통한 의존성 주입

## 📁 프로젝트 구조

```
lib/
├── main.dart                      # 앱 진입점 및 메인 게임 화면
├── constants/
│   └── game_constants.dart        # 모든 게임 상수 중앙 관리
├── models/
│   └── game_models.dart           # 데이터 모델 (Pipe, Bird, GameStats 등)
├── providers/
│   └── game_provider.dart         # Riverpod 상태 관리
├── services/
│   └── storage_service.dart       # 로컬 스토리지 서비스
└── widgets/
    └── game_widgets.dart          # 재사용 가능한 UI 컴포넌트
```

### 각 레이어 설명

#### 1️⃣ Constants Layer (`constants/`)
**목적**: 모든 하드코딩된 값을 중앙에서 관리

```dart
// 물리 상수
GamePhysics.gravity
GamePhysics.jumpVelocity

// 게임 설정
PipeConstants.speed
PipeConstants.gapHeight

// UI 설정
UIConstants.scoreFontSize
GameColors.birdBody
```

**장점**:
- 마법 숫자(Magic Number) 제거
- 게임 밸런싱이 쉬움
- 일관된 디자인 유지

#### 2️⃣ Models Layer (`models/`)
**목적**: 비즈니스 로직과 데이터 구조 정의

주요 모델:
- `Bird`: 새의 물리 및 상태
- `Pipe`: 파이프 생성 및 이동
- `Particle`: 파티클 효과
- `GameStats`: 게임 통계 및 저장

**특징**:
- 불변성(Immutability) 지향
- 명확한 책임 분리
- 테스트 용이성

#### 3️⃣ Providers Layer (`providers/`)
**목적**: 상태 관리 및 게임 로직 제어

```dart
class GameController extends StateNotifier<GameControllerState>
```

**책임**:
- 게임 상태 관리 (ready, playing, gameOver, paused)
- 게임 루프 제어
- 충돌 감지
- 점수 계산
- 파티클 효과 생성

**장점**:
- 반응형 UI 업데이트
- 예측 가능한 상태 변화
- 디버깅 용이

#### 4️⃣ Services Layer (`services/`)
**목적**: 외부 시스템과의 통신 추상화

`StorageService` (싱글톤):
- SharedPreferences를 통한 영구 저장
- 게임 통계 저장/로드
- 설정값 관리

**패턴**:
- 싱글톤 패턴
- 에러 핸들링
- 타입 안전성

#### 5️⃣ Widgets Layer (`widgets/`)
**목적**: 재사용 가능하고 성능 최적화된 UI 컴포넌트

주요 위젯:
- `BirdWidget`: CustomPainter로 새 렌더링
- `PipeWidget`: RepaintBoundary로 최적화
- `ParticleWidget`: 파티클 효과
- `ScoreDisplay`: 점수 표시
- `GameOverlay`: 모달 UI

**최적화 기법**:
- `const` 생성자 활용
- `RepaintBoundary` 사용
- `CustomPainter`로 직접 그리기

## 🎨 핵심 설계 패턴

### 1. MVC 패턴
```
Model (models/)
  ↓
Controller (providers/)
  ↓
View (widgets/, main.dart)
```

### 2. Singleton 패턴
```dart
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();
}
```

### 3. Factory 패턴
```dart
factory Pipe.random() {
  // 랜덤 파이프 생성 로직
}
```

### 4. State 패턴
```dart
enum GameState {
  ready,
  playing,
  gameOver,
  paused,
}
```

## ⚡ 성능 최적화

### 1. 렌더링 최적화
- **RepaintBoundary**: 파이프, 구름 등 독립적인 위젯을 격리
- **CustomPainter**: 새와 구름을 직접 그려 위젯 트리 축소
- **const 생성자**: 불필요한 재생성 방지

### 2. 메모리 최적화
- 화면 밖 파이프 자동 제거
- 만료된 파티클 자동 정리
- 타이머 적절한 dispose

### 3. 물리 시뮬레이션 최적화
```dart
// 60 FPS 게임 루프
Timer.periodic(Duration(milliseconds: 16), (_) => update());

// 속도 제한으로 계산 오버헤드 감소
velocity = velocity.clamp(minVelocity, maxVelocity);
```

## 🔧 확장 가능성

### 쉽게 추가할 수 있는 기능

#### 1. 난이도 시스템
```dart
class DifficultyConstants {
  static const easy = GameDifficulty(...);
  static const hard = GameDifficulty(...);
}
```

#### 2. 사운드 시스템
```dart
class AudioService {
  void playJump();
  void playScore();
  void playHit();
}
```

#### 3. 스킨 시스템
```dart
class BirdSkin {
  final Color bodyColor;
  final Color accentColor;
}
```

#### 4. 멀티플레이어
- GameController를 네트워크 동기화
- Firebase Realtime Database 활용

#### 5. 애니메이션 개선
- Lottie 애니메이션
- Rive 인터랙티브 애니메이션

## 📊 데이터 흐름

```
사용자 입력 (터치/키보드)
  ↓
GameController.jump()
  ↓
Bird 모델 업데이트
  ↓
Riverpod 상태 변경
  ↓
UI 자동 리빌드
```

## 🧪 테스트 전략

### Unit Tests
```dart
test('Bird jump sets correct velocity', () {
  final bird = Bird();
  bird.jump();
  expect(bird.velocity, GamePhysics.jumpVelocity);
});
```

### Widget Tests
```dart
testWidgets('Score displays correctly', (tester) async {
  await tester.pumpWidget(ScoreDisplay(score: 10));
  expect(find.text('10'), findsOneWidget);
});
```

### Integration Tests
```dart
testWidgets('Game over on collision', (tester) async {
  // 게임 시작 → 충돌 시뮬레이션 → 게임오버 확인
});
```

## 🛠️ 개발 도구

### 디버그 모드
```bash
flutter run -d chrome --dart-define=DEBUG_MODE=true
```

디버그 정보 표시:
- Bird Y 위치
- 속도
- 파이프 수
- 파티클 수
- 점프 횟수

### 성능 모니터링
```bash
flutter run --profile -d chrome
```

DevTools에서 확인:
- 프레임 레이트
- 메모리 사용량
- 위젯 리빌드 횟수

## 📝 코딩 컨벤션

### Naming
- 클래스: `PascalCase`
- 변수/함수: `camelCase`
- 상수: `camelCase` (static const)
- Private: `_leadingUnderscore`

### 주석
```dart
/// 공개 API에 대한 문서 주석
///
/// [parameter]에 대한 설명
void publicMethod() {}

// 구현 세부사항 설명
void _privateMethod() {}
```

### 파일 구조
```dart
/// 파일 설명
library;

// imports
import 'package:flutter/material.dart';

// 상수
const kConstant = 10;

// 클래스
class MyClass {}
```

## 🚀 배포

### 웹 빌드
```bash
flutter build web --release
```

### 최적화 옵션
```bash
flutter build web --release --web-renderer canvaskit
```

### GitHub Pages 배포
```bash
flutter build web --release --base-href "/flappy_bird_game/"
```

## 📚 참고 자료

- [Flutter 공식 문서](https://flutter.dev/docs)
- [Riverpod 문서](https://riverpod.dev/)
- [Flutter 성능 최적화](https://flutter.dev/docs/perf)
- [Clean Code in Flutter](https://medium.com/flutter-community)

---

**작성일**: 2025-12-10
**버전**: 2.0.0 (Professional Edition)
**개발자**: Claude Code
