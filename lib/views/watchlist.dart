import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favorites.dart';

class WatchlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Consumer<Favorites>(
        builder: (context, favorites, child) {
          if (favorites.items.isEmpty) {
            return Center(
              child: Text('Your watchlist is empty.'),
            );
          }

          return ListView.builder(
            itemCount: favorites.items.length,
            itemBuilder: (context, index) {
              final movieId = favorites.items[index];

              final String movieName = 'Movie $movieId';

              return ListTile(
                title: Text(movieName),
              );
            },
          );
        },
      ),
    );
  }
}
