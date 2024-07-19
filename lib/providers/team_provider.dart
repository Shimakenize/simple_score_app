import 'package:flutter/material.dart';
import '../models/team.dart';

class TeamProvider with ChangeNotifier {
  List<Team> _teams = [
    Team(id: '1', name: 'Team A'),
    Team(id: '2', name: 'Team B'),
  ];

  List<Team> get teams => _teams;

  Team _homeTeam = Team(id: '1', name: 'Team A');
  Team _awayTeam = Team(id: '2', name: 'Team B');

  Team get homeTeam => _homeTeam;
  Team get awayTeam => _awayTeam;

  void setHomeTeam(Team team) {
    _homeTeam = team;
    notifyListeners();
  }

  void setAwayTeam(Team team) {
    _awayTeam = team;
    notifyListeners();
  }

  // TODO: チームの追加、編集、削除、メンバー管理などの処理を実装
}
