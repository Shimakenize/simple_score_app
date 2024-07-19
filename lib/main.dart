import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './screens/login_screen.dart';  // ログイン画面
import './screens/signup_screen.dart'; // サインアップ画面
import './screens/home_screen.dart';   // ホーム画面
import './providers/auth_provider.dart'; // auth_provider をインポート
import './providers/team_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider( // 複数のProviderを管理
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => TeamProvider()),
      ],
      child: MaterialApp(
        title: 'Simple Score App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(), // 初期画面をログイン画面に設定
        routes: {
          '/signup': (ctx) => SignupScreen(),
          '/home': (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
