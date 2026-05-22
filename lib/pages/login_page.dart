import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'admin_dashboard_page.dart';
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

  bool obscurePassword = true;

  bool isLoading = false;

  Future<void> login() async {

    setState(() {
      isLoading = true;
    });

    final error =
        await AuthService.login(

      username:
          usernameController.text.trim(),

      password:
          passwordController.text.trim(),
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (error != null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          backgroundColor:
              Colors.redAccent,

          content: Text(error),
        ),
      );

      return;
    }

    final isAdmin =
        await AuthService.isAdmin();

    if (!mounted) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder:
            (_) => isAdmin

                ? const AdminDashboardPage()

                : const HomePage(),
      ),
    );
  }

  InputDecoration inputStyle({

    required String hint,

    required IconData icon,

    Widget? suffix,
  }) {

    return InputDecoration(

      hintText: hint,

      hintStyle:
          const TextStyle(
        color: Colors.white54,
      ),

      prefixIcon:
          Icon(
        icon,
        color: Colors.cyanAccent,
      ),

      suffixIcon: suffix,

      filled: true,

      fillColor:
          Colors.white.withOpacity(
        0.06,
      ),

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        borderSide:
            BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context)
            .size
            .width;

    return Scaffold(

      body: Stack(

        children: [

          // BACKGROUND

          Container(

            decoration:
                const BoxDecoration(

              gradient:
                  LinearGradient(

                begin:
                    Alignment.topLeft,

                end:
                    Alignment.bottomRight,

                colors: [

                  Color(0xff071227),

                  Color(0xff0d1f3a),

                  Color(0xff071227),
                ],
              ),
            ),
          ),

          Positioned(

            top: -120,

            left: -120,

            child: Container(

              width: 300,

              height: 300,

              decoration:
                  BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.cyanAccent
                        .withOpacity(
                  0.15,
                ),
              ),
            ),
          ),

          Positioned(

            bottom: -120,

            right: -120,

            child: Container(

              width: 300,

              height: 300,

              decoration:
                  BoxDecoration(

                shape: BoxShape.circle,

                color:
                    Colors.blueAccent
                        .withOpacity(
                  0.12,
                ),
              ),
            ),
          ),

          Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(
                  35,
                ),

                child: BackdropFilter(

                  filter:
                      ImageFilter.blur(

                    sigmaX: 15,

                    sigmaY: 15,
                  ),

                  child: Container(

                    width:
                        width > 600
                            ? 470
                            : double.infinity,

                    padding:
                        const EdgeInsets.all(
                      35,
                    ),

                    decoration:
                        BoxDecoration(

                      color:
                          Colors.white
                              .withOpacity(
                        0.08,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        35,
                      ),

                      border: Border.all(

                        color:
                            Colors.white
                                .withOpacity(
                          0.1,
                        ),
                      ),
                    ),

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Container(

                          padding:
                              const EdgeInsets.all(
                            22,
                          ),

                          decoration:
                              BoxDecoration(

                            shape:
                                BoxShape.circle,

                            gradient:
                                LinearGradient(

                              colors: [

                                Colors.cyanAccent,

                                Colors.blueAccent,
                              ],
                            ),
                          ),

                          child: const Icon(

                            Icons.local_hospital_rounded,

                            color:
                                Colors.white,

                            size: 60,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        const Text(

                          'Clinical Prescription',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 34,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        const Text(

                          'Modern Clinical Management System',

                          textAlign:
                              TextAlign.center,

                          style: TextStyle(

                            color:
                                Colors.white60,

                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        TextField(

                          controller:
                              usernameController,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),

                          decoration:
                              inputStyle(

                            hint:
                                'Username',

                            icon:
                                Icons.person_rounded,
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        TextField(

                          controller:
                              passwordController,

                          obscureText:
                              obscurePassword,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),

                          decoration:
                              inputStyle(

                            hint:
                                'Password',

                            icon:
                                Icons.lock_rounded,

                            suffix:
                                IconButton(

                              onPressed: () {

                                setState(() {

                                  obscurePassword =
                                      !obscurePassword;
                                });
                              },

                              icon: Icon(

                                obscurePassword

                                    ? Icons.visibility_off

                                    : Icons.visibility,

                                color:
                                    Colors.white70,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 35,
                        ),

                        SizedBox(

                          width:
                              double.infinity,

                          height: 58,

                          child:
                              ElevatedButton(

                            style:
                                ElevatedButton.styleFrom(

                              backgroundColor:
                                  Colors.cyanAccent,

                              foregroundColor:
                                  Colors.black,

                              elevation: 12,

                              shadowColor:
                                  Colors.cyanAccent,

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(
                                  22,
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
                                            Colors.black,
                                      )

                                    : const Text(

                                        'LOGIN',

                                        style: TextStyle(

                                          fontWeight:
                                              FontWeight.bold,

                                          fontSize:
                                              18,
                                        ),
                                      ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            const Text(

                              'No account yet? ',

                              style: TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            GestureDetector(

                              onTap: () {

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

                                'Create Account',

                                style: TextStyle(

                                  color:
                                      Colors.cyanAccent,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}