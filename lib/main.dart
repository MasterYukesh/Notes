import 'package:flutter/material.dart';
import 'aboutpage.dart';
import 'homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const HomePage(),
        '/AboutPage': (context) => const AboutPage()
      },
      initialRoute: '/',
    );
  }
}
