import 'package:flutter/material.dart';
import 'package:minimal_music_app/screens/home_screen.dart';
import 'package:minimal_music_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main()
{
  runApp(
    ChangeNotifierProvider(create: (context)=> ThemeProvider(),
    child: const MyApp(),),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
