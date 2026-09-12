import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/app.dart';

void main() {
  testWidgets('Lumen shell shows Today hub', (WidgetTester tester) async {
    await tester.pumpWidget(const LumenApp());
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Your day at a glance.'), findsOneWidget);
  });
}
