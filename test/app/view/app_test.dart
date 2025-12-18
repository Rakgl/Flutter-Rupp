// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_super_aslan_app/app/app.dart';
import 'package:flutter_super_aslan_app/features/counter/view/counter_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
