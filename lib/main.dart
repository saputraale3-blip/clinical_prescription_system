import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';

import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://ktinojqknhqcrullkoqq.supabase.co',

    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0aW5vanFrbmhxY3J1bGxrb3FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkyNzg5OTUsImV4cCI6MjA5NDg1NDk5NX0.iZ_ja6wjymF1cFbk--hqZaxkq0zFzcZOjW1g1wftdOE',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);

    return AnimatedTheme(
      duration: const Duration(
        milliseconds: 350,
      ),

      data:
          themeProvider.isDark
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,

      child: MaterialApp(
        debugShowCheckedModeBanner:
            false,

        title:
            'Clinical Prescription System',

        theme: AppTheme.lightTheme,

        darkTheme: AppTheme.darkTheme,

        themeMode:
            themeProvider.themeMode,

        // =====================================================
        // GLOBAL RESPONSIVE
        // =====================================================

        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(
              textScaler:
                  const TextScaler.linear(
                1.0,
              ),
            ),

            child: AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 300,
              ),

              child: child!,
            ),
          );
        },

        // =====================================================
        // START PAGE
        // =====================================================

        home: const LoginPage(),
      ),
    );
  }
}