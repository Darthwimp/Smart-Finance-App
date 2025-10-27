import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const SmartFinanceApp());
}

class SmartFinanceApp extends StatelessWidget {
  const SmartFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
