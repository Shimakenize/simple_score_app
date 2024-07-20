import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/team.dart';
import '../providers/team_provider.dart';
import './score_record_screen.dart';
import './match_result_screen.dart';
import './team_member_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Score App'),
      ),
      body: Center(
        child: Consumer<TeamProvider>( // Consumerでチームデータの変更を監視
          builder: (context, teamProvider, child) {
            if (teamProvider.isLoading) {  // ローディング中はインジケータを表示
              return CircularProgressIndicator();
            } else if (teamProvider.teams.isEmpty) {
              return Text('チームが登録されていません');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Home Team 選択
                  DropdownButton<Team>(
                    value: teamProvider.homeTeam,
                    items: teamProvider.teams.map((team) {
                      return DropdownMenuItem<Team>(
                        value: team,
                        child: Text(team.name),
                      );
                    }).toList(),
                    onChanged: (team) {
                      teamProvider.setHomeTeam(team!);
                    },
                  ),
                  SizedBox(height: 20),
                  // Away Team 選択
                  DropdownButton<Team>(
                    value: teamProvider.awayTeam,
                    items: teamProvider.teams.map((team) {
                      return DropdownMenuItem<Team>(
                        value: team,
                        child: Text(team.name),
                      );
                    }).toList(),
                    onChanged: (team) {
                      teamProvider.setAwayTeam(team!);
                    },
                  ),
                  SizedBox(height: 20),
                  // 試合種別選択
                  DropdownButton<String>(
                    value: teamProvider.matchType,
                    items: ['公式戦', 'TRM']
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (type) {
                      teamProvider.setMatchType(type!);
                    },
                  ),
                  SizedBox(height: 20),
                  // 試合時間選択
                  DropdownButton<int>(
                    value: teamProvider.gameTime,
                    items: List.generate(45, (index) => index + 1)
                        .map((time) => DropdownMenuItem<int>(
                              value: time,
                              child: Text('$time分'),
                            ))
                        .toList(),
                    onChanged: (time) {
                      teamProvider.setGameTime(time!);
                    },
                  ),
                  SizedBox(height: 20),
                  // ハーフ有無選択
                  DropdownButton<String>(
                    value: teamProvider.halfType,
                    items: ['ハーフあり', 'ハーフ無し']
                        .map((type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (type) {
                      teamProvider.setHalfType(type!);
                    },
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // HomeTeamとAwayTeamが同じでないことを確認してから遷移
                      if (teamProvider.homeTeam != teamProvider.awayTeam) {
                        // 試合開始時に_selectedPlayersをクリア
                        teamProvider.clearSelectedPlayers();

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScoreRecordScreen(),
                          ),
                        );
                      } else {
                        // TODO: エラーメッセージを表示するなど、適切な処理を行う
                        print('Error: Home team and away team cannot be the same.');
                      }
                    },
                    child: Text('試合開始'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MatchResultScreen(),
                        ),
                      );
                    },
                    child: Text('試合結果確認'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => TeamMemberEditScreen(teams: teamProvider.teams),
                        ),
                      );
                    },
                    child: Text('チーム・メンバー設定'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
