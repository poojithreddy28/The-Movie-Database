import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  MovieDetailsScreen({required this.movieId});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Map<String, dynamic> movieDetails = {};
  late List<String> companyLogos = [];
  bool isWatchlisted = false;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchCompanyLogos();
    checkWatchlistStatus();
  }

  Future<void> fetchMovieDetails() async {
    const apiKey = '56a9db44b522dbe6ae259981103007a6';
    const baseUrl = 'https://api.themoviedb.org/3';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/${widget.movieId}?api_key=$apiKey'),
      );

      if (response.statusCode == 200) {
        setState(() {
          movieDetails = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
    }
  }

  Future<void> fetchCompanyLogos() async {
    final apiKey = '56a9db44b522dbe6ae259981103007a6';
    final companyId = widget.movieId;
    final baseUrl = 'https://api.themoviedb.org/3';

    final response = await http.get(
      Uri.parse('$baseUrl/movie/$companyId/images?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> logos = data['logos'];

      setState(() {
        companyLogos = logos.map<String>((logo) => logo['file_path']).toList();
      });
    } else {
      print('Failed to load company logos');
    }
  }

  Future<void> checkWatchlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWatchlisted = prefs.getBool('${widget.movieId}_watchlist') ?? false;
    });
  }

  Future<void> toggleWatchlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWatchlisted = !isWatchlisted;
      prefs.setBool('${widget.movieId}_watchlist', isWatchlisted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '${movieDetails['title'] ?? 'loading'}(${movieDetails['release_date'] != null ? movieDetails['release_date'].substring(0, 4) : ''})',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 30, 51, 76),
      ),
      body: Container(
        color: Color.fromARGB(255, 30, 51, 76),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Overview',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${movieDetails['overview'] ?? 'N/A'}',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                if (companyLogos.isNotEmpty)
                  Center(
                    child: Image.network(
                      'https://image.tmdb.org/t/p/original${companyLogos.first}',
                      fit: BoxFit.contain,
                    ),
                  ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: 'Rating',
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(
                            ' ${movieDetails['vote_average']}/10',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: 'Watch time',
                      child: Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            ' ${movieDetails['runtime']} mins',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: isWatchlisted
                          ? 'Remove from watchlist'
                          : 'Add to watchlist',
                      child: IconButton(
                        icon: Icon(
                          isWatchlisted
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                        onPressed: toggleWatchlistStatus,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
