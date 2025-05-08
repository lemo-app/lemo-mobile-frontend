import 'package:flutter/material.dart';
import 'package:lemoios/provider/learningmode_provider.dart';
import 'package:lemoios/splashscreen/app_splash.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LearningModeProvider()),
      ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const AppSplash(),
    );
  }
}