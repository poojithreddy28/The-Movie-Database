import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/favorites.dart';
import 'movie_details_screen.dart';
import 'favoritespage.dart';
import '../models/shared_preferences_services.dart';

enum MovieCategory {
  nowPlaying,
  upcoming,
  topRated,
  popular,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final apiKey = '56a9db44b522dbe6ae259981103007a6';
  final baseUrl = 'https://api.themoviedb.org/3';
  MovieCategory _selectedCategory = MovieCategory.nowPlaying;
  late List<Map<String, dynamic>> movies = [];
  late Favorites favorites;

  @override
  void initState() {
    super.initState();
    favorites = Provider.of<Favorites>(context, listen: false);
    fetchMovies();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadFavorites();
  }

  Future<void> fetchMovies() async {
    String categoryPath;
    switch (_selectedCategory) {
      case MovieCategory.nowPlaying:
        categoryPath = 'now_playing';
        break;
      case MovieCategory.upcoming:
        categoryPath = 'upcoming';
        break;
      case MovieCategory.topRated:
        categoryPath = 'top_rated';
        break;
      case MovieCategory.popular:
        categoryPath = 'popular';
        break;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$categoryPath?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        setState(() {
          movies = results.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      print('Error fetching movies: $e');
    }
  }

  Future<void> loadFavorites() async {
    final List<int> savedFavorites =
        await SharedPreferencesService().getFavorites();
    savedFavorites.forEach((id) {
      favorites.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = _selectedCategory.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'The Movie Database 📽',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 30, 51, 76),
        actions: [
          Tooltip(
            message: 'Favorite movies',
            child: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<MovieCategory>(
              value: _selectedCategory,
              style: const TextStyle(
                color: Colors.white,
              ),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  fetchMovies();
                });
              },
              items: MovieCategory.values.map((category) {
                return DropdownMenuItem<MovieCategory>(
                  value: category,
                  child: Text(
                    categoryText(category),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              dropdownColor: const Color.fromARGB(255, 30, 51, 76),
            ),
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: favorites,
        child: Builder(
          builder: (context) {
            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = (constraints.maxWidth ~/ 200).clamp(1, 4);

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final isFavorite = Provider.of<Favorites>(context)
                        .items
                        .contains(movies[index]['id']);
                    final imageUrl = movies[index]['poster_path'] != null
                        ? 'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}'
                        : 'https://via.placeholder.com/500x750.png?text=No+Image';

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(
                              movieId: movies[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                imageUrl,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Tooltip(
                                  message: isFavorite
                                      ? 'Remove from favorites'
                                      : 'Mark as favorite',
                                  child: IconButton(
                                    icon: isFavorite
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 30,
                                          )
                                        : const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                    onPressed: () {
                                      Provider.of<Favorites>(context,
                                              listen: false)
                                          .toggle(movies[index]['id']);

                                      SharedPreferencesService().saveFavorites(
                                        Provider.of<Favorites>(context,
                                                listen: false)
                                            .items,
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(isFavorite
                                              ? 'Removed from favorites'
                                              : 'Added to favorites'),
                                          duration:
                                              const Duration(milliseconds: 1500),
                                          action: SnackBarAction(
                                            label: 'Undo',
                                            onPressed: () {
                                              Provider.of<Favorites>(context,
                                                      listen: false)
                                                  .toggle(movies[index]['id']);

                                              SharedPreferencesService()
                                                  .saveFavorites(
                                                Provider.of<Favorites>(context,
                                                        listen: false)
                                                    .items,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  String categoryText(MovieCategory category) {
    switch (category) {
      case MovieCategory.nowPlaying:
        return 'Now Playing';
      case MovieCategory.upcoming:
        return 'Upcoming';
      case MovieCategory.topRated:
        return 'Top Rated';
      case MovieCategory.popular:
        return 'Popular';
    }
  }
}
