import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/main.dart';

void main() {
  testWidgets('Fleet Booking app loads successfully', (
    WidgetTester tester,
  ) async {
    // Build the application.
    await tester.pumpWidget(const FleetBookingApp());

    // Verify that the main application widget is loaded.
    expect(find.byType(FleetBookingApp), findsOneWidget);
  });
}
