import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/favorites.dart';
import 'package:mp5/main.dart';

void main() {
  group('Favorites Model Tests', () {
    test('Adding item to favorites', () {
      final favorites = Favorites();
      favorites.add(1);
      expect(favorites.items, [1]);
    });

    test('Removing item from favorites', () {
      final favorites = Favorites();
      favorites.add(1);
      favorites.remove(1);
      expect(favorites.items, []);
    });

    test('Toggling item in favorites (add)', () {
      final favorites = Favorites();
      favorites.toggle(1);
      expect(favorites.items, [1]);
    });

    test('Toggling item in favorites (remove)', () {
      final favorites = Favorites();
      favorites.add(1);
      favorites.toggle(1);
      expect(favorites.items, []);
    });

    test('Toggling item in favorites (non-existent)', () {
      final favorites = Favorites();
      favorites.toggle(1);
      expect(favorites.items, [1]);
    });
  });
}
