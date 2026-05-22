import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';

import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

Future<void> main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  await Supabase.initialize(

    url:
        'https://ktinojqknhqcrullkoqq.supabase.co',

    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0aW5vanFrbmhxY3J1bGxrb3FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkyNzg5OTUsImV4cCI6MjA5NDg1NDk5NX0.iZ_ja6wjymF1cFbk--hqZaxkq0zFzcZOjW1g1wftdOE',
  );

  runApp(

    ChangeNotifierProvider(

      create:
          (_) =>
              ThemeProvider(),

      child:
          const MyApp(),
    ),
  );
}

class MyApp
    extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final themeProvider =
        Provider.of<ThemeProvider>(
      context,
    );

    return MaterialApp(

      debugShowCheckedModeBanner:
          false,

      title:
          'Clinical Prescription',

      theme:
          AppTheme.lightTheme,

      darkTheme:
          AppTheme.darkTheme,

      themeMode:
          themeProvider.themeMode,

      home:
          const LoginPage(),
    );
  }
}