import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flauraapp/main.dart'; 

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlauraApp());

    // Verify that the app builds without crashing by finding the MaterialApp widget
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}