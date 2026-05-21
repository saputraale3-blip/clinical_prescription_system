import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/login_page.dart';
import 'pages/home_page.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(

    url: 'https://ktinojqknhqcrullkoqq.supabase.co',

    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0aW5vanFrbmhxY3J1bGxrb3FxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkyNzg5OTUsImV4cCI6MjA5NDg1NDk5NX0.iZ_ja6wjymF1cFbk--hqZaxkq0zFzcZOjW1g1wftdOE',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Clinical Prescription System',

      theme: ThemeData.dark(),

      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {

  const AuthGate({super.key});

  @override
  State<AuthGate> createState() =>
      _AuthGateState();
}

class _AuthGateState
    extends State<AuthGate> {

  bool loading = true;

  Widget page =
      const LoginPage();

  @override
  void initState() {

    super.initState();

    checkUser();
  }

  Future<void> checkUser() async {

    final supabase =
        Supabase.instance.client;

    final user =
        supabase.auth.currentUser;

    // =========================
    // NO LOGIN
    // =========================

    if (user == null) {

      setState(() {

        page =
            const LoginPage();

        loading = false;
      });

      return;
    }

    try {

      // =========================
      // GET PROFILE
      // =========================

      final profile =
          await supabase

              .from('profiles')

              .select()

              .eq('id', user.id)

              .single();

      final approved =
          profile['approved'] ?? false;

      // =========================
      // NOT APPROVED
      // =========================

      if (approved != true) {

        await supabase.auth.signOut();

        setState(() {

          page =
              const LoginPage();

          loading = false;
        });

        return;
      }

      // =========================
      // APPROVED
      // =========================

      setState(() {

        page =
            const HomePage();

        loading = false;
      });
    }

    catch (e) {

      await supabase.auth.signOut();

      setState(() {

        page =
            const LoginPage();

        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {

      return const MaterialApp(

        debugShowCheckedModeBanner:
            false,

        home: Scaffold(

          body: Center(

            child:
                CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(

      debugShowCheckedModeBanner:
          false,

      home: page,
    );
  }
}