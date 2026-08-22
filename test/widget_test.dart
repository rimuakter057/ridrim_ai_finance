import 'package:flutter_test/flutter_test.dart';

import 'package:ridrim/main.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RidRimApp());
    await tester.pump();

    expect(find.text('RidRim'), findsOneWidget);
  });
}
