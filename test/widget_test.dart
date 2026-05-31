import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tenp_member_ecosystem/app.dart';

void main() {
  testWidgets('App shell renders home', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TenpApp()));

    expect(find.text('10th Planet Member Ecosystem'), findsOneWidget);
  });
}
