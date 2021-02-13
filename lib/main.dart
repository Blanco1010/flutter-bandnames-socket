import 'package:flutter/material.dart';
import 'package:bands_name/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Material APP",
      initialRoute: 'home',
      routes: {'home': (_) => HomePage()},
    );
  }
}
