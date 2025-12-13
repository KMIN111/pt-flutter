# Personal Therapy: AI 기반 정신 건강 관리 플랫폼

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-02569B?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Wear OS](https://img.shields.io/badge/Wear%20OS-supported-4285F4?logo=wearos)](https://wearos.google.com)

**Personal Therapy**는 감정 추적, 건강 지표 모니터링, AI 상담 기능을 통합한 종합 정신 건강 관리 Flutter 애플리케이션입니다. 웨어러블 기기(Galaxy Watch) 연동을 통해 실시간 생체 데이터를 수집하고, Google Gemini AI를 활용한 개인화된 심리 상담을 제공합니다.

---

## ✨ 주요 기능

### 🎯 1. 정서 상태 추적 및 분석
- **감정 기록**: 일간/주간/월간 단위로 감정 변화를 기록하고 시각화
- **감정 분포 분석**: 긍정/부정/중립 감정의 패턴 파악
- **추이 그래프**: fl_chart 라이브러리를 활용한 시각화
- **데이터 기반 인사이트**: Firestore 스트림 기반 실시간 분석

### 💓 2. 종합 건강 지표 모니터링

#### 📱 Health Connect 통합 (Android)
- **걸음 수**: 일일 활동량 추적
- **심박수**: 실시간 및 안정시 심박수 모니터링
- **HRV (심박변이도)**: RMSSD 기반 스트레스 수준 측정
- **수면 데이터**: 수면 시간 및 품질 분석
- **혈중 산소 포화도**: SpO2 모니터링
- **칼로리 소모량**: 활동 칼로리 추적

#### ⌚ Wear OS 앱 (Galaxy Watch 전용)
- **실시간 HRV 측정**: Health Services API를 활용한 고품질 심박 데이터 수집
- **자동 측정**: 5분 주기로 1분간 심박수 측정 및 HRV 계산
- **IBI (Inter-Beat Interval) 데이터**: 정확한 RR Interval 기반 RMSSD 계산
- **워치-폰 동기화**: Wearable Data Layer API를 통한 실시간 데이터 전송
- **포그라운드 서비스**: 백그라운드에서도 안정적인 측정 지속

**3단계 폴백 시스템:**
1. Health Connect에서 데이터 조회
2. Health Connect 실패 시 Samsung Health SDK 시도
3. 데이터 없을 시 심박수 기반 HRV 추정

### 🤖 3. AI 기반 심리 상담
- **Google Gemini 2.5 Flash API**: 최신 생성형 AI 모델 활용
- **한국어 맞춤형 상담**: 문화적 맥락을 고려한 심리 지원
- **대화 기록 관리**: 상담 내역 보존 및 연속성 유지
- **안전한 API 키 관리**: flutter_dotenv를 통한 환경 변수 관리

### 📊 4. 스트레스 분석 시스템
- **다차원 분석**: 심박수, HRV, 수면 패턴 종합 평가
- **스트레스 점수 계산**: 정규화된 HR(60%)과 HRV(40%) 가중 평균
- **시간대별 분석**: 2시간 간격으로 스트레스 변화 추적
- **개인화된 권장사항**: 분석 결과 기반 맞춤형 조언 제공

### 🆘 5. 안심 연락망 관리
- **비상 연락처 등록**: Firestore 기반 연락처 관리
- **빠른 접근**: 홈 화면에서 원터치 액세스
- **생명의전화 1393**: 위기 상황 시 즉시 연결

### 🎵 6. 힐링 콘텐츠 제공
- **YouTube 통합**: youtube_player_flutter를 통한 명상/힐링 콘텐츠
- **맞춤형 추천**: 사용자 상태 기반 콘텐츠 큐레이션

---

## 🏗️ 기술 스택

### 프레임워크 & 언어
- **Flutter** `^3.9.2` - 크로스 플랫폼 UI 프레임워크
- **Dart** - 프로그래밍 언어

### 백엔드 & 인증
- **Firebase Core** `^3.2.0` - Firebase 플랫폼 초기화
- **Firebase Auth** `^5.1.2` - 사용자 인증 (이메일/비밀번호, Google Sign-In)
- **Cloud Firestore** `^5.1.0` - NoSQL 클라우드 데이터베이스
  - 실시간 데이터 동기화
  - 컬렉션 구조: `users/{uid}/mood_scores`, `mental_health_scores`, `sleep_records`, `hrv_records`

### AI & API
- **Google Gemini 2.5 Flash API** - 생성형 AI 상담
- **HTTP** `^1.2.0` - REST API 통신
- **flutter_dotenv** `^5.1.0` - 환경 변수 관리

### 건강 데이터 통합
- **health** `^13.2.1` - HealthKit (iOS) 및 Health Connect (Android) 통합
- **Samsung Health SDK** - 네이티브 Kotlin 채널을 통한 통합
- **Wear OS Health Services API** - Galaxy Watch 고품질 센서 데이터 접근

### UI & 시각화
- **google_fonts** `^6.2.1` - Roboto 폰트 사용
- **fl_chart** `^0.68.0` - 감정/건강 추이 그래프
- **youtube_player_flutter** `^9.0.0` - 힐링 콘텐츠 재생

### 로컬 저장소
- **shared_preferences** `^2.2.3` - 로컬 key-value 저장소

### Wear OS (Kotlin)
- **Health Services Client** - Galaxy Watch 센서 접근
- **Wearable Data Layer** - 워치-폰 데이터 동기화
- **Coroutines** - 비동기 처리

---

## 🏛️ 아키텍처

### 애플리케이션 진입 및 네비게이션 플로우

```
main.dart
    ↓ (Firebase 초기화, .env 로드)
auth_wrapper.dart
    ↓
    ├─ (미인증) → login_screen.dart → signup_screen.dart
    └─ (인증됨) → main_screen.dart (Bottom Navigation)
                    ├─ 홈 탭 (mood check, diagnosis, wearable, healing)
                    ├─ 상담 탭 (aichat_screen.dart - Gemini AI)
                    ├─ 추적 탭 (emotion_tracking_tab.dart - 일/주/월 분석)
                    └─ 프로필 탭 (profile_tab.dart - 계정 관리)
```

### Firestore 데이터 구조

```
users/{uid}
├── Fields:
│   ├── name: String
│   ├── email: String
│   ├── createdAt: Timestamp
│   ├── conversationCount: int
│   ├── averageHealthScore: double
│   ├── healingContentCount: int
│   └── emergencyContacts: Array<Map>
│
├── mood_scores/{doc_id}
│   ├── score: int (1-10)
│   └── timestamp: Timestamp
│
├── mental_health_scores/{doc_id}
│   ├── score: int
│   └── timestamp: Timestamp
│
├── sleep_records/{YYYY-MM-DD}
│   ├── duration: double (hours)
│   └── timestamp: Timestamp
│
├── hrv_records/{doc_id}
│   ├── rmssd: double (ms)
│   ├── avgHeartRate: int (bpm)
│   ├── timestamp: Timestamp
│   ├── source: String (wear_os_watch | health_connect | estimated)
│   └── formattedTime: String
│
└── health_data/{doc_id}
    ├── steps: int
    ├── activeCalories: double
    ├── currentHR: int
    ├── currentHRV: int
    ├── restingHR: int
    └── timestamp: Timestamp
```

### 상태 관리 패턴

- **StatefulWidget + StreamBuilder**: Firestore 실시간 동기화
- **MethodChannel**: Flutter ↔ Native (Kotlin/Swift) 통신
- **LifecycleService (Wear OS)**: 포그라운드 서비스 수명 주기 관리

---

## 🚀 설치 및 실행 가이드

### 📋 사전 요구사항

1. **개발 환경**
   - [Flutter SDK](https://flutter.dev/docs/get-started/install) `3.9.2+`
   - Android Studio 또는 Xcode (플랫폼별)
   - Git

2. **Firebase 프로젝트 설정**
   ```bash
   # FlutterFire CLI 설치
   dart pub global activate flutterfire_cli

   # Firebase 프로젝트 생성 후 앱 등록
   flutterfire configure
   ```

   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

3. **Google Gemini API 키 발급**
   - [Google AI Studio](https://ai.google.dev) 접속
   - API 키 생성

### ⚙️ 설치 단계

#### 1. 리포지토리 클론
```bash
git clone https://github.com/Personal-Therapy/pt-flutter.git
cd personal_therapy
```

#### 2. 환경 변수 설정
프로젝트 루트에 `.env` 파일 생성:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

#### 3. 의존성 설치

**Flutter 패키지:**
```bash
flutter pub get
```

**iOS CocoaPods (macOS 전용):**
```bash
cd ios && pod install && cd ..
```

**Android Gradle 동기화:**
```bash
cd android && ./gradlew build && cd ..
```

#### 4. Health Connect 설정 (Android)

**Android 14+ 기기:**
1. Google Play Store에서 "Health Connect" 앱 설치
2. Health Connect 열기 → 데이터 소스 연결
3. Samsung Health 또는 Google Fit 선택

**앱 권한 요청:**
- 앱 첫 실행 시 자동으로 Health Connect 권한 요청
- `HealthService.requestAuthorization()` 메서드 실행

#### 5. Wear OS 앱 설치 (Galaxy Watch 전용)

**워치 개발자 모드 활성화:**
```bash
# 워치: 설정 → 시스템 → 정보 → 소프트웨어 정보
# "소프트웨어 버전"을 7번 연속 탭

# 개발자 옵션 → ADB 디버깅 켜기
```

**APK 빌드 및 설치:**
```bash
# Wear OS 앱 빌드
cd android
./gradlew :wear:assembleDebug

# ADB 연결 확인
adb devices

# APK 설치
adb install wear/build/outputs/apk/debug/wear-debug.apk
```

**워치에서 앱 실행:**
1. 앱 목록에서 "PT Watch" 실행
2. 권한 허용 (신체 센서, 알림)
3. "측정 시작" 버튼 클릭

자세한 사용 가이드: [WEAR_OS_USAGE.md](./WEAR_OS_USAGE.md)

#### 6. 애플리케이션 실행

**기본 실행:**
```bash
flutter run
```

**특정 기기 선택:**
```bash
# 사용 가능한 기기 목록 확인
flutter devices

# 특정 기기에서 실행
flutter run -d <device_id>
```

**릴리즈 모드 (최적화):**
```bash
flutter run --release
```

---

## 📱 주요 화면 구성

### 1. 홈 화면 (`main_screen.dart`)
- 빠른 기분 체크 (1-10 슬라이더)
- 정신건강 진단 링크
- 웨어러블 기기 연동 상태
- 오늘의 힐링 콘텐츠
- 긴급 연락망 (생명의전화 1393)

### 2. 상담 탭 (`aichat_screen.dart`)
- Google Gemini AI 챗봇
- 실시간 대화 인터페이스
- 메시지 히스토리 관리

### 3. 추적 탭 (`emotion_tracking_tab.dart`)
- 일간/주간/월간 토글
- 기분 점수 차트
- 정신 건강 점수 차트
- 평균 스트레스/건강/수면 요약
- 빠른 액션 버튼 (AI 채팅, 힐링)

### 4. 프로필 탭 (`profile_tab.dart`)
- 건강 상태 카드 (건강 점수, 수면 시간, 걸음 수)
- 비상 연락처 관리
- 알림 설정
- 계정 관리 (로그아웃, 계정 삭제)

### 5. 웨어러블 기기 화면 (`wearable_device_screen.dart`)
- Health Connect 상태 확인
- 연결된 기기 목록
- 최신 HRV 데이터 표시
- 권한 관리

---

## 🧪 개발 명령어

### 코드 품질 검사
```bash
# Dart 코드 분석
flutter analyze

# 린팅 규칙: analysis_options.yaml
```

### 빌드
```bash
# Android APK
flutter build apk

# Android App Bundle (Play Store용)
flutter build appbundle

# iOS (macOS 전용)
flutter build ios

# 빌드 아티팩트 정리
flutter clean
```

### 디버깅
```bash
# 상세 로그 출력
flutter run -v

# Hot Reload: 코드 수정 후 'r' 키
# Hot Restart: 상태 리셋 후 재시작 'R' 키
```

---

## 🔐 보안 고려사항

### API 키 관리
- ❌ **절대 금지**: API 키를 코드에 하드코딩
- ✅ **권장**: `.env` 파일 사용 + `.gitignore`에 추가
- ✅ **프로덕션**: Firebase Remote Config 또는 환경별 설정 파일

### Firebase 보안 규칙
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

### 권한 관리
- **최소 권한 원칙**: 필요한 권한만 요청
- **런타임 권한 확인**: Android 6.0+ 대응
- **사용자 동의**: Health 데이터 수집 전 명확한 안내

---

## 🌐 플랫폼별 특이사항

### iOS
- **최소 배포 타겟**: iOS 13+
- **HealthKit 권한**: `Info.plist`에 사용 목적 명시 필수
  ```xml
  <key>NSHealthShareUsageDescription</key>
  <string>건강 데이터를 읽어 스트레스 분석에 활용합니다.</string>
  <key>NSHealthUpdateUsageDescription</key>
  <string>건강 데이터를 기록하여 추적 기능을 제공합니다.</string>
  ```
- **CocoaPods**: 종속성 추가 시 `pod install` 필수

### Android
- **최소 SDK**: API 26 (Android 8.0)
- **타겟 SDK**: Flutter 기본값 (API 34+)
- **MultiDex**: Firebase로 인한 메서드 수 초과 대응 (자동 활성화)
- **Health Connect**: Android 14+ 권장 (이전 버전은 Google Fit 사용)

### Wear OS
- **지원 기기**: Galaxy Watch 4/5/6 (Wear OS 3.0+)
- **필수 권한**: `BODY_SENSORS`, `POST_NOTIFICATIONS`
- **Health Services**: 고품질 센서 데이터 접근
- **배터리 최적화**: 5분 주기 측정으로 배터리 소모 최소화

---

## 📊 성능 최적화

### Firestore 쿼리 최적화
- **인덱스 활용**: 복합 쿼리는 Firebase Console에서 인덱스 생성
- **제한된 읽기**: `limit()`, `orderBy()` 사용으로 불필요한 데이터 조회 방지
- **StreamBuilder**: 필요한 위젯에만 스트림 구독

### 네트워크 최적화
- **캐싱**: Health 데이터는 로컬 저장소에 캐싱 (구현 예정)
- **배치 처리**: 여러 Firestore 작업을 `batch()` 또는 `transaction()`으로 묶기

### UI 성능
- **const 생성자**: 불변 위젯은 `const` 키워드 사용
- **ListView.builder**: 긴 목록은 lazy loading
- **이미지 최적화**: 웹 이미지는 캐싱, 로컬 이미지는 적절한 해상도 사용

---

## 🐛 문제 해결

### Health Connect 권한 문제
```bash
# Health Connect 앱 설치 확인
adb shell pm list packages | grep healthconnect

# 권한 재설정
Settings → Apps → Personal Therapy → Permissions → Health Connect
```

### Firebase 구성 오류
```bash
# Firebase 설정 재생성
flutterfire configure

# 생성된 파일 확인
# - lib/firebase_options.dart
# - android/app/google-services.json
# - ios/Runner/GoogleService-Info.plist
```

### Wear OS 연결 실패
```bash
# ADB 디버깅 재시작
adb kill-server
adb start-server
adb devices

# Wi-Fi 연결 (USB 케이블 없이)
# 워치 IP 주소 확인: 설정 → Wi-Fi → 네트워크 세부정보
adb connect <watch-ip>:5555
```

### Gemini API 응답 없음
- `.env` 파일에 API 키 확인
- API 키 활성화 상태 확인 ([Google AI Studio](https://ai.google.dev))
- 네트워크 연결 확인
- API 할당량 초과 여부 확인

---

## 🤝 기여하기

프로젝트 개선을 위한 기여는 언제나 환영합니다!

### 기여 방법
1. 이 저장소를 Fork
2. Feature 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push (`git push origin feature/AmazingFeature`)
5. Pull Request 생성

### 코드 스타일
- Dart 공식 스타일 가이드 준수
- `flutter analyze` 경고 없이 통과
- 주요 로직에 주석 추가

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](./LICENSE) 파일을 참조하세요.

---

## 📞 문의

- **GitHub Issues**: [프로젝트 이슈 페이지](https://github.com/Personal-Therapy/pt-flutter/issues)
- **이메일**: [프로젝트 담당자 이메일]

---

## 🙏 감사의 말

- **Flutter 팀**: 크로스 플랫폼 프레임워크 제공
- **Firebase**: 강력한 백엔드 인프라
- **Google Gemini**: 혁신적인 AI 상담 기능
- **Health Connect**: 건강 데이터 통합 플랫폼
- **모든 기여자 및 사용자**

---

**Personal Therapy**로 당신의 마음 건강을 함께 관리하세요! 💚
