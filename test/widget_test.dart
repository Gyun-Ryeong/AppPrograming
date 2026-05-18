// MEF 앱 기본 위젯 테스트
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mef/main.dart';

void main() {
  testWidgets('MEF 앱 기본 렌더링 테스트', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MefApp()),
    );

    // 앱 이름 MEF가 화면에 표시되는지 확인
    expect(find.text('MEF'), findsOneWidget);
  });
}
