import 'package:simplescoreapp2024/models/player.dart';

class Team {
  final String id;
  final String name;
  List<Player> players;

  Team({
    required this.id,
    required this.name,
    this.players = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

