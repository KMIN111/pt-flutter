# 정신건강 종합 점수 시스템 구현 요약

제공해주신 요구사항에 따라 정신건강 종합 점수 시스템이 `FirestoreService`에 구현되었습니다. 핵심 로직은 사용자의 다양한 정신건강 관련 데이터를 종합하여 일일 종합 점수를 계산하고, 이를 Firestore에 체계적으로 저장하는 것입니다.

## 1. 종합 점수 데이터 구조 (`mentalstatus`)

요구사항의 `mentalstatus` 변수는 Firestore의 `daily_mental_status`라는 하위 컬렉션에 일자별 문서로 저장되도록 구현되었습니다. 이를 통해 일별 데이터 추적 및 분석이 용이합니다.

**저장 경로:** `/users/{uid}/daily_mental_status/{YYYY-MM-DD}`

**저장 데이터 예시:**
```json
{
  "date": "2023-10-27",
  "overallScore": 75.0,
  "componentScores": {
    "selfDiagnosis": {
      "average": 80,
      "우울증 자가진단": 70,
      "불안장애 자가진단": 90
    },
    "dailyEmotion": {
      "moodCheck": 75,
      "aiConversation": { "average": null },
      "average": 75.0
    },
    "biometricStress": null
  },
  "weights": {
    "selfDiagnosis": 0.5,
    "dailyEmotion": 0.5,
    "biometricStress": 0.0
  },
  "lastUpdated": "October 27, 2023 at 10:30:00 AM UTC+9"
}
```
- `overallScore`: 모든 구성 요소 점수와 가중치를 반영한 최종 종합 점수 (0-100).
- `componentScores`: 각 구성 요소별 점수를 구조적으로 저장합니다.
- `weights`: 해당 날짜의 점수 계산에 실제 사용된 가중치를 저장하여 투명성을 확보합니다.

## 2. 구성 요소별 점수 반영 로직

### 가. 자가진단 기반 점수 (가중치 40%)

- **로직:** `updateMentalHealthScore` 함수가 호출될 때마다 해당 날짜에 완료된 모든 자가진단(`mental_health_scores` 컬렉션)의 `normalizedScore`(0-100으로 정규화된 점수)를 다시 불러와 평균을 계산합니다.
- **구현:** `updateDailyMentalStatus` 함수 내에서 Firestore 쿼리를 통해 당일의 모든 자가진단 기록을 가져와 평균(`average`)을 계산하고, 각 테스트(`testType`)별 최신 점수도 함께 저장합니다.
- **반영:** **"검사한 것들만 평균내서 반영"** 요구사항이 충족되었습니다.

### 나. 일상 감정 상태 점수 (가중치 40%)

- **로직:** `dailyEmotion` 항목 아래에 `moodCheck`(기분 체크)와 `aiConversation`(AI 대화 분석) 점수를 각각 저장할 수 있는 구조를 마련했습니다.
- **구현:** `updateDailyMentalStatus` 함수는 `moodCheckScore`와 `aiConversationScore`를 인자로 받아 `componentScores.dailyEmotion` 내부에 저장합니다. 현재는 각 점수가 독립적으로 전달되면 업데이트되는 방식입니다.
- **반영:** 향후 기분 체크 기능과 AI 대화 분석 기능이 추가되면 해당 점수를 `updateDailyMentalStatus` 함수에 전달하여 종합 점수에 반영할 수 있습니다.

### 다. 생체 스트레스 점수 (가중치 20%)

- **로직:** `biometricStress` 점수를 저장할 수 있는 필드를 `componentScores` 내부에 마련했습니다.
- **구현:** `updateDailyMentalStatus` 함수는 `biometricStressScore`를 인자로 받아 저장할 수 있습니다.
- **반영:** 센서 데이터 연동 시 `biometricStressScore`를 전달하여 종합 점수에 반영할 수 있습니다.

## 3. 가중치 동적 조정 로직

- **로직:** 특정 구성 요소의 점수가 없는 경우, 해당 구성 요소의 가중치를 나머지 사용 가능한 구성 요소에 비례하여 재분배합니다.
- **구현:** `updateDailyMentalStatus` 함수는 각 구성 요소 점수의 존재 여부를 확인(`null` 체크)하여 `totalAvailableWeight`을 계산하고, 이를 기반으로 각 항목의 최종 가중치를 정규화(normalize)합니다. 예를 들어, 생체 스트레스 점수가 없으면 자가진단과 일상 감정의 가중치 비율(4:4)에 따라 최종 가중치가 각각 0.5로 조정됩니다.
- **반영:** **"자가진단을 하나도 안 했으면? → 일상 감정 + 센서만으로 계산 (비율 재조정)"** 등 가중치 조정 요구사항이 완벽하게 구현되었습니다.

## 4. 데이터 흐름 및 업데이트 트리거

1.  사용자가 자가진단을 완료하면 `SurveyScreen`에서 `firestoreService.updateMentalHealthScore`를 호출합니다.
2.  `updateMentalHealthScore` 함수는 전달받은 점수(10-50점)를 0-100점으로 정규화(`normalizedScore`)하여 `mental_health_scores` 컬렉션에 저장합니다.
3.  이후, **`updateDailyMentalStatus` 함수를 자동으로 호출**하여 방금 추가된 데이터를 포함한 모든 일일 데이터를 재계산하고 `daily_mental_status` 문서를 업데이트합니다.

이러한 흐름을 통해 데이터가 발생할 때마다 항상 최신 상태의 종합 점수가 유지됩니다.
