import 'package:crud_employee/dad_jokes/joke_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/joke_provider.dart';

class DadJokesScreen extends StatefulWidget {
  @override
  State<DadJokesScreen> createState() => _DadJokesScreenState();
}

class _DadJokesScreenState extends State<DadJokesScreen> {
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchJoke();
  }

  void _fetchJoke() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<JokeProvider>().fetchJoke();
    } catch (e) {
      _error = 'Failed to fetch joke.';
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final joke = context.watch<JokeProvider>().currentJoke;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dad Jokes'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JokeHistoryScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : _error != null
            ? Text(_error!)
            : joke == null
            ? Text('No joke loaded.')
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            joke.text,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchJoke,
        tooltip: 'Get Another Joke',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
