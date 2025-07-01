import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/joke_provider.dart';


class JokeHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final jokes = context.watch<JokeProvider>().history;
    final df = DateFormat('dd MMM yyyy – HH:mm');

    return Scaffold(
      appBar: AppBar(title: Text('Joke History')),
      body: jokes.isEmpty
          ? Center(child: Text('No joke history yet.'))
          : ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return ListTile(
            title: Text(joke.text),
            subtitle: Text(df.format(joke.fetchedAt)),
          );
        },
      ),
    );
  }
}
