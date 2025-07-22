import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_loading_page.dart';

void main() {
  testWidgets('Loading page renders successfully', (WidgetTester tester) async {
    // Build our test loading page and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: TestLoadingPage())),
    );

    // Verify that the CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Verify that we have a Scaffold
    expect(find.byType(Scaffold), findsOneWidget);

    // Verify that the loading indicator is centered
    expect(find.byType(Center), findsOneWidget);
  });
}
