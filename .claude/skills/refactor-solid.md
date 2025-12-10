---
name: refactor-solid
description: SOLID 원칙에 따라 코드를 리팩토링합니다
arguments:
  - name: file_path
    description: 리팩토링할 파일 경로
    required: true
  - name: principle
    description: 적용할 원칙 (SRP/OCP/LSP/ISP/DIP 또는 all)
    required: false
    default: "all"
---

# SOLID 원칙 기반 리팩토링

{{file_path}} 파일을 SOLID 원칙에 따라 리팩토링합니다.

## 적용할 원칙: {{principle}}

### S - Single Responsibility Principle (단일 책임 원칙)
{{#if principle === "SRP" || principle === "all"}}

**목표**: 각 클래스는 하나의 책임만 가져야 합니다.

**체크리스트**:
1. 이 클래스가 변경되어야 하는 이유가 2가지 이상인가?
2. 클래스 이름이 "And"나 "Manager" 같은 단어를 포함하는가?
3. 메서드들이 서로 다른 목적을 가지는가?

**리팩토링 방법**:
- 각 책임을 별도 클래스로 분리
- 명확한 이름으로 각 클래스의 책임 표현
- 필요시 Facade 패턴으로 통합

**예시**:
```dart
// Before: 여러 책임을 가진 클래스
class GameManager {
  void updatePhysics() {}
  void renderGraphics() {}
  void playSound() {}
  void saveScore() {}
}

// After: 책임별로 분리
class PhysicsEngine {
  void update() {}
}

class Renderer {
  void render() {}
}

class AudioManager {
  void play() {}
}

class ScoreRepository {
  void save() {}
}
```
{{/if}}

### O - Open/Closed Principle (개방/폐쇄 원칙)
{{#if principle === "OCP" || principle === "all"}}

**목표**: 확장에는 열려있고 수정에는 닫혀있어야 합니다.

**체크리스트**:
1. 새로운 기능을 추가할 때 기존 코드를 수정하는가?
2. if-else나 switch 문이 많은가?
3. 하드코딩된 값이나 로직이 있는가?

**리팩토링 방법**:
- 추상 클래스나 인터페이스 사용
- Strategy 패턴 적용
- 설정값을 외부로 분리

**예시**:
```dart
// Before: 새로운 적 타입마다 코드 수정
void spawnEnemy(String type) {
  if (type == 'basic') {
    // basic enemy 생성
  } else if (type == 'fast') {
    // fast enemy 생성
  }
}

// After: 확장 가능한 구조
abstract class Enemy {
  void spawn();
}

class BasicEnemy extends Enemy {
  @override
  void spawn() { /* ... */ }
}

class FastEnemy extends Enemy {
  @override
  void spawn() { /* ... */ }
}
```
{{/if}}

### L - Liskov Substitution Principle (리스코프 치환 원칙)
{{#if principle === "LSP" || principle === "all"}}

**목표**: 하위 타입은 상위 타입을 대체할 수 있어야 합니다.

**체크리스트**:
1. 자식 클래스가 부모 클래스의 동작을 완전히 변경하는가?
2. 부모 클래스 메서드를 호출할 수 없는 경우가 있는가?
3. instanceof나 runtimeType 체크가 많은가?

**리팩토링 방법**:
- 잘못된 상속 구조 재설계
- Composition over Inheritance 적용
- 올바른 추상화 수준 설정
{{/if}}

### I - Interface Segregation Principle (인터페이스 분리 원칙)
{{#if principle === "ISP" || principle === "all"}}

**목표**: 클라이언트는 사용하지 않는 메서드에 의존하지 않아야 합니다.

**체크리스트**:
1. 인터페이스나 추상 클래스가 너무 많은 메서드를 가지는가?
2. 구현 클래스에서 빈 메서드나 예외를 던지는 메서드가 있는가?

**리팩토링 방법**:
- 큰 인터페이스를 작은 인터페이스들로 분리
- 역할별 인터페이스 정의
{{/if}}

### D - Dependency Inversion Principle (의존성 역전 원칙)
{{#if principle === "DIP" || principle === "all"}}

**목표**: 고수준 모듈은 저수준 모듈에 의존하지 않아야 합니다.

**체크리스트**:
1. 구체적인 클래스를 직접 인스턴스화하는가?
2. Singleton이나 Global 변수를 사용하는가?
3. Provider를 사용하지 않고 의존성을 주입하는가?

**리팩토링 방법**:
- Riverpod Provider로 의존성 주입
- 추상화에 의존하도록 변경
- Factory 패턴 사용

**예시**:
```dart
// Before: 구체적인 구현에 의존
class GameScreen {
  final storageService = StorageService.instance; // Singleton

  void save() {
    storageService.save(); // 구체적인 구현에 의존
  }
}

// After: 추상화에 의존
abstract class Storage {
  void save();
}

class GameScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageProvider); // Provider로 주입
    return ElevatedButton(
      onPressed: () => storage.save(),
      child: Text('Save'),
    );
  }
}

final storageProvider = Provider<Storage>((ref) => StorageService());
```
{{/if}}

## 리팩토링 프로세스

1. **현재 상태 분석**
   - {{file_path}} 파일 읽기
   - 위반되는 원칙 파악

2. **문제점 식별**
   - 각 SOLID 원칙 위반 사항 나열
   - 우선순위 결정

3. **리팩토링 계획**
   - 변경할 부분 명시
   - 예상 파일 구조

4. **리팩토링 실행**
   - 단계별로 코드 수정
   - 각 단계마다 테스트

5. **검증**
   - flutter analyze 실행
   - 개선 사항 확인

## 완료 후 리포트

리팩토링 완료 후 다음 정보를 제공:

```
## ✅ SOLID 리팩토링 완료

### 적용된 원칙
- [원칙]: [구체적인 변경 사항]

### 생성/수정된 파일
- [파일 경로]: [변경 내용]

### 개선 효과
- 코드 라인 수: Before → After
- 클래스 수: Before → After
- 순환 복잡도: Before → After

### 추가 권장사항
- [향후 개선 방향]
```
