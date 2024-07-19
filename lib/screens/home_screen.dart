import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/team_provider.dart';
import './score_record_screen.dart';
import './match_result_screen.dart';
import './team_member_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    // teamProvider が初期化されるまで待つ
    if (teamProvider.teams.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Score App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: DropdownButtonでチーム選択を実装
            DropdownButton(
              value: teamProvider.homeTeam,
              items: teamProvider.teams.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Text(team.name),
                );
              }).toList(),
              onChanged: (value) {
                teamProvider.setHomeTeam(value!);
              },
            ),
            DropdownButton(
              value: teamProvider.awayTeam,
              items: teamProvider.teams.map((team) {
                return DropdownMenuItem(
                  value: team,
                  child: Text(team.name),
                );
              }).toList(),
              onChanged: (value) {
                teamProvider.setAwayTeam(value!);
              },
            ),
            // TODO: 試合種別、試合時間、ハーフ有無の選択メニューを実装
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ScoreRecordScreen(),
                  ),
                );
              },
              child: Text('試合開始'),
            ),
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
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TeamMemberEditScreen(),
                  ),
                );
              },
              child: Text('チーム・メンバー設定'),
            ),
          ],
        ),
      ),
    );
  }
}
