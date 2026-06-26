import 'package:flutter/material.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/editor_screen.dart';

class NodespenApp extends StatelessWidget {
  const NodespenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodespen',
      debugShowCheckedModeBanner: false,
      theme: NodespenTheme.darkTheme,
      home: const EditorScreen(),
    );
  }
}
