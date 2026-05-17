import 'package:flutter_test/flutter_test.dart';

import 'package:frontend_flutter/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BankSampahApp(isLoggedIn: false));

    // Verify that the login page is shown.
    expect(find.text('BANK SAMPAH'), findsOneWidget);
    expect(find.text('MASUK →'), findsOneWidget);
  });
}
