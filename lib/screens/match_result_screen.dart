import 'package:flutter/material.dart';

class MatchResultScreen extends StatelessWidget { // 閉じ括弧を追加
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('試合結果'),
      ),
      body: Center(
        child: Text('試合結果画面'), // TODO: 試合結果画面のUIを実装
      ),
    );
  }
} 
