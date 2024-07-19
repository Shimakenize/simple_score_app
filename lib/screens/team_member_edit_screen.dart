import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/team_provider.dart';

class TeamMemberEditScreen extends StatelessWidget { // 閉じ括弧を追加
  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);
    return Scaffold( // 閉じ括弧を追加
      appBar: AppBar(
        title: Text('チーム・メンバー編集'),
      ),
      body: Center(
        child: Text('チーム・メンバー編集画面'), // TODO: チーム・メンバー編集画面のUIを実装
      ),
    );
  }
} 
