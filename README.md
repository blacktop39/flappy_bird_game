# 🐦 Flappy Bird Game - Professional Edition

프로페셔널 아키텍처로 재탄생한 Flutter 플래피 버드 게임!

## 🎮 게임 플레이

**GitHub Pages에서 바로 플레이**: https://blacktop39.github.io/flappy_bird_game/

## ✨ 게임 특징

- 🐦 **귀여운 새**: 노란색 새가 하늘을 날아다닙니다
- 🟢 **파이프 장애물**: 초록색 파이프를 피해 날아가세요
- 🏆 **점수 시스템**: 파이프를 통과할 때마다 점수 획득
- 💾 **최고 점수 저장**: 브라우저에 최고 점수 기록
- 🌤️ **아름다운 배경**: 하늘색 그라데이션과 구름
- 🎨 **부드러운 애니메이션**: 새의 날개짓과 회전 애니메이션

## 🕹️ 조작법

### 🖱️ **마우스**
- **클릭**: 새를 위로 날리기

### ⌨️ **키보드**  
- **스페이스바**: 새를 위로 날리기
- **엔터**: 새를 위로 날리기
- **위 화살표**: 새를 위로 날리기

### 📱 **모바일**
- **터치**: 화면을 터치해서 새를 날리기

## 🚀 게임 시작하기

1. **"🚀 게임 시작"** 버튼 클릭 또는 화면 터치
2. **새를 조종**하여 파이프 사이를 통과
3. **점수를 쌓고** 최고 기록에 도전!
4. **충돌 시** 게임 오버, "🔄 다시 시작"으로 재시도

## 🎯 게임 규칙

- 파이프에 충돌하면 게임 오버
- 바닥이나 천장에 닿아도 게임 오버
- 파이프를 통과할 때마다 1점 획득
- 최고 점수는 자동으로 저장됩니다

## 🛠️ 개발 정보

### 기술 스택
- **Framework**: Flutter 3.24.5
- **Platform**: Web (크로스 플랫폼 지원)
- **State Management**: Riverpod 2.6.1
- **Storage**: SharedPreferences 2.5.4
- **Architecture**: MVC Pattern

### 주요 기능
- ✅ **Riverpod 상태 관리**: 반응형 상태 관리로 예측 가능한 UI
- ✅ **영구 저장소**: SharedPreferences로 최고 점수 영구 보존
- ✅ **모듈화된 아키텍처**: 관심사 분리 (Models, Views, Controllers)
- ✅ **성능 최적화**: RepaintBoundary, CustomPainter, const 위젯
- ✅ **물리 엔진**: 정교한 중력, 속도 제한, 충돌 감지
- ✅ **파티클 시스템**: 점수 획득 시 파티클 효과
- ✅ **반응형 디자인**: 다양한 화면 크기 지원
- ✅ **타입 안전성**: 완벽한 null safety
- ✅ **확장 가능성**: 쉬운 기능 추가 및 커스터마이징

### 코드 품질
- 📝 **상수 관리**: 모든 설정값을 중앙에서 관리
- 🔧 **의존성 주입**: Riverpod Provider 패턴
- 🧪 **테스트 가능**: 각 레이어가 독립적으로 테스트 가능
- 📚 **문서화**: 상세한 주석과 아키텍처 문서
- 🎯 **디자인 패턴**: Singleton, Factory, State 패턴 적용

## 📱 모바일 지원

iPhone Safari에서 "홈 화면에 추가"를 하면 앱처럼 사용할 수 있습니다!

## 🔧 로컬 개발

```bash
# 의존성 설치
flutter pub get

# 웹에서 실행
flutter run -d chrome

# 디버그 모드로 실행 (성능 정보 표시)
flutter run -d chrome --dart-define=DEBUG_MODE=true

# 웹 빌드
flutter build web --release
```

### 프로젝트 구조
```
lib/
├── main.dart                    # 메인 앱
├── constants/
│   └── game_constants.dart      # 게임 상수
├── models/
│   └── game_models.dart         # 데이터 모델
├── providers/
│   └── game_provider.dart       # 상태 관리
├── services/
│   └── storage_service.dart     # 스토리지
└── widgets/
    └── game_widgets.dart        # UI 컴포넌트
```

### 아키텍처 문서
상세한 아키텍처 설명은 [ARCHITECTURE.md](ARCHITECTURE.md)를 참고하세요.

## 🎨 게임 디자인

- **색상**: 하늘색과 초록색 테마
- **스타일**: 픽셀 아트 스타일
- **UI**: 심플하고 직관적인 인터페이스
- **애니메이션**: 부드럽고 자연스러운 움직임

## 🏆 도전 과제

- [ ] 점수 10점 달성
- [ ] 점수 25점 달성  
- [ ] 점수 50점 달성
- [ ] 점수 100점 달성 (전문가!)

---

**재미있게 플레이하세요!** 🎮✨

Made with ❤️ using Flutter