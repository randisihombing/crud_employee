import 'package:hive/hive.dart';

part 'joke_model.g.dart';

@HiveType(typeId: 1)
class Joke extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final DateTime fetchedAt;

  Joke({
    required this.text,
    required this.fetchedAt,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'fetchedAt': fetchedAt.toIso8601String(),
  };
}
