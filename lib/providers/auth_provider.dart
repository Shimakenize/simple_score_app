import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ログイン
  Future<void> login(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamed(context, '/home'); // ログイン成功後にホーム画面に遷移
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // メールアドレスが登録されていない場合のエラー処理
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('エラー'),
            content: Text('メールアドレスが登録されていません'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        // パスワードが間違っている場合のエラー処理
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('エラー'),
            content: Text('パスワードが間違っています'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // その他のエラーの場合のエラー処理
        print('ログインエラー: ${e.message}'); 
      }
    }
  }

  // サインアップ
  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // TODO: エラーハンドリング
      if (e.code == 'weak-password') {
        print('パスワードが弱すぎます');
      } else if (e.code == 'email-already-in-use') {
        print('このメールアドレスは既に使用されています');
      } else {
        print('サインアップエラー: ${e.message}');
      }
    }
  }

  // ゲストログイン
  Future<void> guestLogin() async {
    try {
      await _auth.signInAnonymously();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // TODO: エラーハンドリング
      print('ゲストログインエラー: ${e.message}');
    }
  }

  // ログアウト
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
