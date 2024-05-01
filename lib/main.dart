import 'package:flutter/material.dart';
import 'package:todospring/models/gamble.dart';
import 'Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const List<Gamble> gambleList = [];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(gambleList: gambleList,page:1,username: "",password: ""),
      );
  }
}
