import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oivan_project/bootstrap.dart';
import 'package:oivan_project/presentation/users_page.dart';

Future<void> main() async {
  final container = await bootstrap();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oivan Project',
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfffe5020),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfffe5020)),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const UsersPage(),
    );
  }
}
