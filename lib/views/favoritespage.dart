// FavoritesPage.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorites.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.white, // Set text color to white
            fontWeight: FontWeight.bold, // Set font weight to bold
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 30, 51, 76), // Set the background color
        centerTitle: true, // Center the title text
      ),
      body: Consumer<Favorites>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.items.length,
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemBuilder: (context, index) {
              final int movieId = value.items[index];
              return FutureBuilder<Movie>(
                // Assuming you have a Future<Movie> function to get movie details by ID
                future: getMovieDetailsById(movieId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data available');
                  } else {
                    return FavoriteItemTile(snapshot.data!);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteItemTile extends StatelessWidget {
  const FavoriteItemTile(this.movie, {Key? key}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.primaries[movie.id % Colors.primaries.length],
        ),
        title: Text(
          movie.title,
          key: Key('favorites_text_${movie.id}'),
          style: TextStyle(
            color: Color.fromARGB(255, 3, 2, 2),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          key: Key('remove_icon_${movie.id}'),
          icon: const Icon(Icons.close),
          onPressed: () async {
            Provider.of<Favorites>(context, listen: false).remove(movie.id);

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setStringList(
              'favorites',
              Provider.of<Favorites>(context, listen: false)
                  .items
                  .map((id) => id.toString())
                  .toList(),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites.'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Movie {
  final int id;
  final String title;

  Movie({
    required this.id,
    required this.title,
  });
}

Future<Movie> getMovieDetailsById(int id) async {
  const apiKey = '56a9db44b522dbe6ae259981103007a6';
  const baseUrl = 'https://api.themoviedb.org/3';

  try {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/$id?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> movieDetails = json.decode(response.body);
      final String title = movieDetails['title'];

      return Movie(
        id: id,
        title: title,
      );
    } else {
      throw Exception('Failed to load movie details');
    }
  } catch (e) {
    print('Error fetching movie details: $e');
    throw Exception('Error fetching movie details');
  }
}
