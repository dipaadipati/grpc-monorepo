// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mobile/gen/app.pbgrpc.dart';
import 'package:mobile/grpc_service.dart';

import 'package:mobile/main.dart';
import 'package:mobile/pages/main_navigation_holder.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    GrpcService().init();

    await Hive.initFlutter();
    final authBox = await Hive.openBox('authBox');

    final String? savedSessionId = authBox.get('session_id');

    bool isSessionValid = false;
    UserProfile? userProfile;

    if (savedSessionId != null && savedSessionId.isNotEmpty) {
      try {
        userProfile = await GrpcService().fetchProfileWithToken(savedSessionId);
        isSessionValid = true;

        GrpcService().setSessionIdToMetadata(savedSessionId);
      } catch (e) {
        debugPrint('Sesi expired atau Redis telah dihapus: $e');
        await authBox.delete('session_id');
      }
    }
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(
        initialScreen: isSessionValid && userProfile != null
            ? MainNavigationHolder(profile: userProfile)
            : const GymLoginPage(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
