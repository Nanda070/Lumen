import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen/app.dart';
import 'package:lumen/data/app_database.dart';

void main() {
  testWidgets('Onboarding appears when profile is missing', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(LumenApp(database: db));
    await tester.pumpAndSettle();

    expect(find.text('What should we call you?'), findsOneWidget);
  });

  testWidgets('Shell shows Today hub after profile exists', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await db.completeOnboarding(
      displayName: 'Alex',
      localeCode: 'en',
      countryCode: 'US',
      currencyCode: 'USD',
    );

    await tester.pumpWidget(LumenApp(database: db));
    await tester.pumpAndSettle();

    expect(find.text('Today'), findsWidgets);
    expect(find.text('Your day at a glance.'), findsOneWidget);
  });
}
