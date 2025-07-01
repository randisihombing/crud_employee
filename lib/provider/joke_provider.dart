import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/joke_model.dart';


class JokeProvider extends ChangeNotifier {
  final _box = Hive.box<Joke>('jokes');
  Joke? _currentJoke;
  Joke? get currentJoke => _currentJoke;

  List<Joke> get history => _box.values.toList().reversed.toList();

  Future<void> fetchJoke() async {
    final url = Uri.parse('https://icanhazdadjoke.com/');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final jokeText = data['joke'];

      final joke = Joke(
        text: jokeText,
        fetchedAt: DateTime.now(),
      );

      _box.add(joke);
      _currentJoke = joke;
      notifyListeners();
    } else {
      throw Exception('Failed to load joke');
    }
  }
}
