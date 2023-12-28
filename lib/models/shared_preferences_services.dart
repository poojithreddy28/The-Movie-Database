import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String _favoritesKey = 'favorites';

  Future<void> saveFavorites(List<int> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        _favoritesKey, favorites.map((id) => id.toString()).toList());
  }

  Future<List<int>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList(_favoritesKey);
    return favorites?.map((id) => int.parse(id)).toList() ?? [];
  }

  static const String _watchlistKey = 'watchlist';

  Future<void> saveWatchlist(List<int> watchlist) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      _watchlistKey,
      watchlist.map((id) => id.toString()).toList(),
    );
  }

  Future<List<int>> getWatchlist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? watchlist = prefs.getStringList(_watchlistKey);
    return watchlist?.map((id) => int.parse(id)).toList() ?? [];
  }
}
