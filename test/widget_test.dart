import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tenp_member_ecosystem/app.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: TenpApp()));
    await tester.pump();
    // The router redirects unauthenticated users to /auth.
    // We just verify the app renders without throwing.
    expect(find.byType(ProviderScope), findsOneWidget);
  });
}
