import 'package:cloud_firestore/cloud_firestore.dart';
import 'player.dart';

class Team {
  final String id;
  final String name;
  List<Player> players;

  Team({
    required this.id,
    required this.name,
    this.players = const [],
  });

  // Firestore から Team オブジェクトを作成
  factory Team.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<dynamic> playersData = data['players'] ?? []; // playersフィールドが存在しない場合は空のリストを返す
    return Team(
      id: doc.id,
      name: data['name'],
      players: playersData.map((playerData) => Player.fromMap(playerData)).toList(),
    );
  }

  // Team オブジェクトを Firestore に保存する形式に変換
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'players': players.map((player) => player.toMap()).toList(),
    };
  }

  // copyWith メソッドを追加
  Team copyWith({
    String? id,
    String? name,
    List<Player>? players,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      players: players ?? this.players,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Team &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

