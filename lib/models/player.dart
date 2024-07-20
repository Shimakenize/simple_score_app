class Player {
  final String name;
  final int backNumber;
  bool isSelected; // isSelected プロパティを追加

  Player({
    required this.name,
    required this.backNumber,
    this.isSelected = false, // デフォルト値はfalse
  });

  // MapからPlayerオブジェクトを作成
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'],
      backNumber: map['backNumber'],
      isSelected: map['isSelected'] ?? false, // isSelected が null の場合は false
    );
  }

  // PlayerオブジェクトをMapに変換
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'backNumber': backNumber,
      'isSelected': isSelected,
    };
  }
}
