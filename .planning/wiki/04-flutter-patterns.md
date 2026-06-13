# Flutter / Riverpod 패턴 정리

> 이 프로젝트에서 실제로 쓰인 Flutter + Riverpod 패턴을 정리한다.
> 공식 문서 요약이 아니라, MEF 코드베이스에서 쓰인 구체적 패턴.

---

## Riverpod — 핵심 패턴

### AsyncNotifier (비동기 상태)

API 호출처럼 비동기 작업의 상태(loading / data / error)를 관리할 때 사용.

```dart
// providers/scenario_provider.dart 패턴

@riverpod
class ScenarioNotifier extends AsyncNotifier<Scenario?> {
  @override
  Future<Scenario?> build() async => null; // 초기 상태: null

  Future<void> generateScenario({
    required String situation,
    required String difficulty,
    required String category,
  }) async {
    state = const AsyncValue.loading(); // 로딩 상태로 전환
    try {
      final scenario = await ScenarioService().generateScenario(
        situation: situation,
        difficulty: difficulty,
        category: category,
      );
      state = AsyncValue.data(scenario); // 성공
    } catch (e, stack) {
      state = AsyncValue.error(e, stack); // 실패
    }
  }
}
```

### Notifier (동기 상태)

대화 메시지 리스트처럼 비동기 없이 메모리에서 관리할 때 사용.

```dart
// providers/conversation_provider.dart 패턴

@riverpod
class ConversationNotifier extends Notifier<List<Message>> {
  @override
  List<Message> build() => []; // 초기 상태: 빈 리스트

  void addMessage(Message message) {
    state = [...state, message]; // 불변 업데이트 — state에 직접 mutation 금지
  }

  void clear() {
    state = [];
  }
}
```

> **주의**: `state.add(message)` 는 동작하지 않는다. `state = [...state, message]` 처럼 새 리스트를 할당해야 한다.

---

## 화면에서 Riverpod 사용

### ConsumerWidget — 상태 구독

```dart
class ScenarioResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue 구독
    final scenarioAsync = ref.watch(scenarioNotifierProvider);

    return scenarioAsync.when(
      loading: () => const LoadingOverlay(),
      error: (e, _) => Center(child: Text('오류: $e')),
      data: (scenario) {
        if (scenario == null) return const SizedBox.shrink();
        return ScenarioCard(scenario: scenario);
      },
    );
  }
}
```

### 버튼에서 Notifier 메서드 호출

```dart
ElevatedButton(
  onPressed: () {
    // ref.read (일회성 호출) — ref.watch가 아님!
    ref.read(scenarioNotifierProvider.notifier).generateScenario(
      situation: _situationController.text,
      difficulty: _selectedDifficulty,
      category: _selectedCategory,
    );
  },
  child: const Text('시나리오 생성'),
),
```

> **watch vs read**: 빌드 중 상태를 구독(리빌드 트리거)하면 `watch`, 버튼 콜백처럼 일회성 액션이면 `read`.

---

## go_router 라우팅 패턴

### 화면 이동

```dart
// 단순 이동
context.go('/home');

// 스택에 쌓기 (뒤로 가기 가능)
context.push('/conversation');

// 데이터 전달 (extra)
context.push('/conversation', extra: scenario);
```

### extra로 데이터 받기

```dart
// app_router.dart
GoRoute(
  path: '/conversation',
  builder: (context, state) {
    final scenario = state.extra as Scenario;
    return ConversationScreen(scenario: scenario);
  },
),
```

---

## 공통 위젯 사용법

### LoadingOverlay

```dart
// API 호출 중 화면 전체 로딩 표시
if (isLoading) return const LoadingOverlay();
```

### ChatBubble

```dart
// 대화 메시지 말풍선
ChatBubble(
  message: message.content,
  isUser: message.isUser,
)
```

### PrimaryButton

```dart
// 앱 전체 통일된 주요 버튼
PrimaryButton(
  text: '시나리오 생성',
  onPressed: isLoading ? null : _onGeneratePressed,
)
```

---

## 레이어별 책임 분리 원칙

```dart
// ❌ 잘못된 예: 화면에서 직접 API 호출
class BadScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final response = await http.post(...); // 화면에서 직접 호출 금지
      },
      child: Text('생성'),
    );
  }
}

// ✅ 올바른 예: provider → service 위임
class GoodScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(scenarioNotifierProvider.notifier).generateScenario(...); // provider 경유
      },
      child: Text('생성'),
    );
  }
}
```

---

## 불변 상태 업데이트 패턴

Riverpod의 state는 항상 새 객체로 교체해야 한다.

```dart
// 리스트 항목 추가
state = [...state, newItem];

// 리스트 항목 제거
state = state.where((item) => item.id != targetId).toList();

// 객체 필드 업데이트 (copyWith 패턴)
state = state.copyWith(score: newScore);
```

---

## 자주 쓰는 Flutter 위젯 패턴

### 키보드 위 입력창 (채팅 화면)

```dart
Scaffold(
  body: Column(
    children: [
      Expanded(
        child: ListView.builder(
          reverse: true, // 최신 메시지가 아래
          itemCount: messages.length,
          itemBuilder: (context, index) => ChatBubble(...),
        ),
      ),
      // 키보드가 올라와도 입력창이 가려지지 않음
      SafeArea(
        child: Row(
          children: [
            Expanded(child: TextField(...)),
            IconButton(...),
          ],
        ),
      ),
    ],
  ),
)
```

### ChoiceChip (난이도/카테고리 선택)

```dart
Wrap(
  children: difficulties.map((d) => ChoiceChip(
    label: Text(d),
    selected: _selectedDifficulty == d,
    onSelected: (_) => setState(() => _selectedDifficulty = d),
  )).toList(),
)
```
