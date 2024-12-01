import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(const Game());

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fun Time',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
