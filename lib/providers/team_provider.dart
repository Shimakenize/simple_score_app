import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // WidgetsBindingObserverを使うためにインポート
import 'dart:convert';
import 'package:csv/csv.dart'; // csv パッケージをインポート
import 'package:file_picker/file_picker.dart';

import '../models/team.dart';
import '../models/player.dart';
import '../screens/team_member_edit_screen.dart';

class TeamProvider with ChangeNotifier, WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Team> _teams = [];

  Stream<QuerySnapshot> get teamsStream => _firestore.collection('teams').snapshots();

  List<Team> get teams => _teams;

  Team? _homeTeam;
  Team? _awayTeam;
  String _matchType = '公式戦';
  int _gameTime = 3;
  String _halfType = 'ハーフ無し';

  Team? get homeTeam => _homeTeam;
  Team? get awayTeam => _awayTeam;
  String get matchType => _matchType;
  int get gameTime => _gameTime;
  String get halfType => _halfType;

  bool _isLoading = true; // ローディング状態を示す変数

  bool get isLoading => _isLoading;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetchAndSetTeams();
    }
  }

  void setHomeTeam(Team team) {
    _homeTeam = team;
    notifyListeners();
  }

  void setAwayTeam(Team team) {
    _awayTeam = team;
    notifyListeners();
  }

  void setMatchType(String type) {
    _matchType = type;
    notifyListeners();
  }

  void setGameTime(int time) {
    _gameTime = time;
    notifyListeners();
  }

  void setHalfType(String type) {
    _halfType = type;
    notifyListeners();
  }

  Future<void> fetchAndSetTeams() async {
    _isLoading = true; // データ取得開始
    notifyListeners();

    try {
      final querySnapshot = await _firestore.collection('teams').get();
      _teams = querySnapshot.docs.map((doc) => Team.fromFirestore(doc)).toList();

      // ドロップダウンの初期値を設定
      if (_teams.isNotEmpty) {
        _homeTeam ??= _teams[0]; // nullの場合のみ初期値を設定
        _awayTeam ??= _teams[1]; // nullの場合のみを設定
      }
    } catch (error) {
      // TODO: エラーハンドリング
      print('Error fetching teams: $error');
    } finally {
      _isLoading = false; // データ取得終了
      notifyListeners();
    }
  }

  Future<void> addTeam(String name) async {
    try {
      final newTeam = Team(
        id: _firestore.collection('teams').doc().id,
        name: name,
        players: [],
      );
      await _firestore.collection('teams').doc(newTeam.id).set(newTeam.toFirestore());
      _teams.add(newTeam);
      notifyListeners();
    } catch (error) {
      // TODO: エラーハンドリング
      print('Error adding team: $error');
    }
  }

  Future<void> deleteTeam(String id) async {
    try {
      await _firestore.collection('teams').doc(id).delete();
      _teams.removeWhere((team) => team.id == id);
      notifyListeners();
    } catch (error) {
      // TODO: エラーハンドリング
      print('Error deleting team: $error');
    }
  }

  Future<void> updateTeam(String id, String name) async {
    try {
      await _firestore.collection('teams').doc(id).update({'name': name});
      final index = _teams.indexWhere((team) => team.id == id);
      if (index != -1) {
        _teams[index] = _teams[index].copyWith(name: name);
        notifyListeners();
      }
    } catch (error) {
      // TODO: エラーハンドリング
      print('Error updating team: $error');
    }
  }

  void clearSelectedPlayers() {
    for (var team in _teams) {
      for (var player in team.players) {
        player.isSelected = false;
      }
    }
    notifyListeners();
  }

  Future<void> importPlayersFromCsv(String csvData, String teamId) async {
    try {
      final rowsAsListOfValues = const CsvToListConverter().convert(csvData); // CSVデータをパース
      final teamIndex = _teams.indexWhere((team) => team.id == teamId);
      if (teamIndex == -1) return;

      _teams[teamIndex] = _teams[teamIndex].copyWith(players: rowsAsListOfValues.map((row) {
        return Player(name: row[1].toString(), backNumber: int.tryParse(row[0].toString()) ?? 0);
      }).toList());

      // Firestoreに更新を反映
      await _firestore.collection('teams').doc(teamId).set(_teams[teamIndex].toFirestore());

      notifyListeners();
    } catch (error) {
      // TODO: エラーハンドリング
      print('Error importing players from CSV: $error');
    }
  }
}
