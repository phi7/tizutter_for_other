import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_model.dart';
import 'bottom_navigation/bottom_navigation_page.dart';
import 'login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tizutter',
        theme: ThemeData(
          // テーマカラー
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            // デフォルト文字列のスタイル
            bodyText2: TextStyle(fontSize: 20),
            // テキストボタンのスタイル
            button: TextStyle(fontSize: 20),
          ),
          // ボタンのスタイル
          outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
            primary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(),
          ))
        ),
        // ログイン画面を表示
        // home: BottomNavigationPage(),
        home: _LoginCheck(),
      ),
    );
  }
}

class _LoginCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    final bool _loggedIn = context.watch<AuthModel>().loggedIn;
    return _loggedIn
        ? BottomNavigationPage()
        : LoginPage();
  }
}


