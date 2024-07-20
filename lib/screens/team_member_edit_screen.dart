import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/team_provider.dart';
import '../models/team.dart';
import '../models/player.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class TeamMemberEditScreen extends StatefulWidget {
  final List<Team> teams;

  TeamMemberEditScreen({required this.teams});

  @override
  _TeamMemberEditScreenState createState() => _TeamMemberEditScreenState();
}

class _TeamMemberEditScreenState extends State<TeamMemberEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  Team? _selectedTeam; // 選択中のチームを保持

  @override
  void initState() {
    super.initState();
    _selectedTeam = widget.teams.first; // 初期選択チームを設定
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('チーム・メンバー編集'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // チーム選択ドロップダウン
                DropdownButton<Team>(
                  value: _selectedTeam,
                  items: widget.teams.map((team) {
                    return DropdownMenuItem<Team>(
                      value: team,
                      child: Text(team.name),
                    );
                  }).toList(),
                  onChanged: (team) {
                    setState(() {
                      _selectedTeam = team;
                      _teamNameController.text = team!.name;
                    });
                  },
                ),
                SizedBox(height: 20),
                // チーム名編集
                TextFormField(
                  controller: _teamNameController,
                  decoration: InputDecoration(labelText: 'チーム名'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'チーム名を入力してください';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // メンバー編集
                if (_selectedTeam != null)
                  Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true, // ListViewをColumn内で使うために必要
                        physics: NeverScrollableScrollPhysics(), // スクロールを無効にする
                        itemCount: _selectedTeam!.players.length,
                        itemBuilder: (context, index) {
                          final player = _selectedTeam!.players[index];
                          return ListTile(
                            title: Text('背番号${player.backNumber}: ${player.name}'),
                            // TODO: 各メンバーの編集・削除機能を実装
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['csv'],
                          );
                          if (result != null) {
                            String csvData = utf8.decode(result.files.single.bytes!);
                            await teamProvider.importPlayersFromCsv(csvData, _selectedTeam!.id);
                          }
                        },
                        child: Text('CSV入力'),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedTeam != null) { // 選択中のチームがある場合のみ更新
                        await teamProvider.updateTeam(_selectedTeam!.id, _teamNameController.text);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text('保存'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
