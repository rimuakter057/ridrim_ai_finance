import 'package:flutter_test/flutter_test.dart';

import 'package:ai_saas/main.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RimRidFinance());
    await tester.pump();

    expect(find.text('RimRid Finance'), findsOneWidget);
  });
}
