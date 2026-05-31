import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class TenpApp extends StatelessWidget {
  const TenpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '10th Planet Ecosystem',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
