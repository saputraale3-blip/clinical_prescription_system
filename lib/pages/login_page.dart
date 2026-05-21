import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  // =========================
  // LOGIN
  // =========================

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final error =
        await AuthService.login(

      username:
          usernameController.text,

      password:
          passwordController.text,
    );

    // =========================
    // LOGIN FAILED
    // =========================

    if (error != null) {

      if (mounted) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          SnackBar(
            content: Text(error),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });

      return;
    }

    // =========================
    // CHECK APPROVAL
    // =========================

    final supabase =
        Supabase.instance.client;

    final user =
        supabase.auth.currentUser;

    if (user == null) {

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {

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

        if (mounted) {

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(

            const SnackBar(

              content: Text(
                'Account pending admin approval',
              ),
            ),
          );
        }

        setState(() {
          isLoading = false;
        });

        return;
      }

      // =========================
      // LOGIN SUCCESS
      // =========================

      if (mounted) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder:
                (_) =>
                    const HomePage(),
          ),
        );
      }
    }

    catch (e) {

      await supabase.auth.signOut();

      if (mounted) {

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(

          SnackBar(
            content:
                Text(e.toString()),
          ),
        );
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(
            24,
          ),

          child: Column(

            children: [

              const Icon(

                Icons.medical_services,

                color: Colors.cyanAccent,

                size: 90,
              ),

              const SizedBox(height: 20),

              const Text(

                'Clinical Prescription System',

                textAlign:
                    TextAlign.center,

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 28,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              // =========================
              // USERNAME
              // =========================

              TextField(

                controller:
                    usernameController,

                style:
                    const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                    InputDecoration(

                  hintText:
                      'Username',

                  hintStyle:
                      const TextStyle(
                    color:
                        Colors.white54,
                  ),

                  prefixIcon:
                      const Icon(

                    Icons.person,

                    color:
                        Colors.white70,
                  ),

                  filled: true,

                  fillColor:
                      const Color(
                    0xFF1E1E1E,
                  ),

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // PASSWORD
              // =========================

              TextField(

                controller:
                    passwordController,

                obscureText: true,

                style:
                    const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                    InputDecoration(

                  hintText:
                      'Password',

                  hintStyle:
                      const TextStyle(
                    color:
                        Colors.white54,
                  ),

                  prefixIcon:
                      const Icon(

                    Icons.lock,

                    color:
                        Colors.white70,
                  ),

                  filled: true,

                  fillColor:
                      const Color(
                    0xFF1E1E1E,
                  ),

                  border:
                      OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(
                      14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =========================
              // LOGIN BUTTON
              // =========================

              SizedBox(

                width:
                    double.infinity,

                height: 55,

                child:
                    ElevatedButton(

                  onPressed:
                      isLoading
                          ? null
                          : login,

                  style:
                      ElevatedButton.styleFrom(

                    backgroundColor:
                        Colors.cyanAccent,

                    foregroundColor:
                        Colors.black,
                  ),

                  child:

                      isLoading

                          ? const CircularProgressIndicator()

                          : const Text(

                              'LOGIN',

                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // REGISTER BUTTON
              // =========================

              TextButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:
                          (_) =>
                              const RegisterPage(),
                    ),
                  );
                },

                child: const Text(

                  'Create new account',

                  style: TextStyle(

                    color:
                        Colors.cyanAccent,

                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}