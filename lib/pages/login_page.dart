import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'home_page.dart';
import 'admin_dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {

  const LoginPage({
    super.key,
  });

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

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final result =
        await AuthService.login(

      username:
          usernameController.text,

      password:
          passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    // LOGIN GAGAL

    if (result != null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(result),
        ),
      );

      return;
    }

    // CHECK ADMIN

    final isAdmin =
        await AuthService.isAdmin();

    if (!mounted) return;

    // ADMIN

    if (isAdmin) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder:
              (_) =>
                  const AdminDashboardPage(),
        ),
      );
    }

    // USER

    else {

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF0F172A),

      body: Center(

        child: SingleChildScrollView(

          child: Padding(

            padding:
                const EdgeInsets.all(
              24,
            ),

            child: Container(

              constraints:
                  const BoxConstraints(
                maxWidth: 420,
              ),

              padding:
                  const EdgeInsets.all(
                28,
              ),

              decoration:
                  BoxDecoration(

                color:
                    const Color(
                  0xFF1E293B,
                ),

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: Column(

                mainAxisSize:
                    MainAxisSize.min,

                children: [

                  const Icon(

                    Icons.local_hospital_rounded,

                    size: 80,

                    color:
                        Colors.cyan,
                  ),

                  const SizedBox(height: 20),

                  const Text(

                    'Clinical Prescription System',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    'Login to continue',

                    style: TextStyle(

                      color:
                          Colors.white
                              .withOpacity(
                        0.7,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  TextField(

                    controller:
                        usernameController,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      labelText:
                          'Username',

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          const Color(
                        0xFF334155,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller:
                        passwordController,

                    obscureText: true,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      labelText:
                          'Password',

                      labelStyle:
                          const TextStyle(
                        color:
                            Colors.white70,
                      ),

                      filled: true,

                      fillColor:
                          const Color(
                        0xFF334155,
                      ),

                      border:
                          OutlineInputBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 55,

                    child: ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.cyan,

                        shape:
                            RoundedRectangleBorder(

                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
                      ),

                      onPressed:
                          isLoading
                              ? null
                              : login,

                      child:
                          isLoading

                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )

                              : const Text(

                                  'LOGIN',

                                  style: TextStyle(

                                    fontWeight:
                                        FontWeight.bold,

                                    fontSize: 16,
                                  ),
                                ),
                    ),
                  ),

                  const SizedBox(height: 20),

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
                            Colors.cyan,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}