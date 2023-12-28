// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
/*
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mp5/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
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
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/views/favoritespage.dart';
import 'package:mp5/views/movie_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:mp5/models/favorites.dart';
import 'package:mp5/views/home_screen.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) => Favorites(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );

void main() {
  group('Home Screen Widget Tests', () {
    testWidgets('Testing AppBar', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of the AppBar
      expect(find.byType(AppBar), findsOneWidget);

      // Verify the title of the AppBar
      expect(find.text('The Movie Database 📽'), findsOneWidget);
    });
/*
    testWidgets('Testing DropdownButton', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of the DropdownButton
      expect(find.byType(DropdownButton<MovieCategory>), findsOneWidget);

      // Tap the dropdown button and verify the dropdown items
      await tester.tap(find.byType(DropdownButton<MovieCategory>));
      await tester.pumpAndSettle();
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
    });
*/
    testWidgets('Testing Grid Items', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of Grid Items
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('Testing Favorites Button', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the presence of Favorites Button
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
/*
    testWidgets('Testing Favorites Toggle', (tester) async {
      await tester.pumpWidget(createHomeScreen());

      // Verify the absence of the favorite icon initially
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap the favorite button and verify the appearance of the favorite icon
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Tap the favorite button again and verify the disappearance of the favorite icon
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.favorite), findsNothing);
    });
    */
  });
}
