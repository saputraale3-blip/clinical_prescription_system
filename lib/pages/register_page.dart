import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final usernameController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  bool isLoading = false;

  Future<void> register() async {

    final username =
        usernameController.text.trim();

    final password =
        passwordController.text.trim();

    final phone =
        phoneController.text.trim();

    if (username.isEmpty ||
        password.isEmpty ||
        phone.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
              Text('All fields required'),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final result =
        await AuthService.register(

      username: username,

      password: password,

      phone: phone,
    );

    setState(() {
      isLoading = false;
    });

    if (result != null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(result),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
            Text('Register Success'),
      ),
    );

    Navigator.pop(context);
  }

  InputDecoration cyberInput({

    required String hint,

    required IconData icon,

  }) {

    return InputDecoration(

      hintText: hint,

      hintStyle: TextStyle(
        color:
            Colors.white.withOpacity(0.5),
      ),

      prefixIcon: Icon(
        icon,
        color: Colors.cyanAccent,
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.04),

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide:
            BorderSide(
          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(18),

        borderSide:
            BorderSide(
          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      focusedBorder:
          const OutlineInputBorder(

        borderSide:
            BorderSide(
          color: Colors.cyanAccent,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff020617),

      body: Stack(

        children: [

          // =========================
          // BACKGROUND GLOW
          // =========================

          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.cyanAccent
                        .withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.blueAccent
                        .withOpacity(0.08),
              ),
            ),
          ),

          // =========================
          // CONTENT
          // =========================

          Center(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(34),

                child: BackdropFilter(

                  filter:
                      ImageFilter.blur(

                    sigmaX: 18,
                    sigmaY: 18,
                  ),

                  child: Container(

                    width: 430,

                    padding:
                        const EdgeInsets.all(34),

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(34),

                      color:
                          Colors.white
                              .withOpacity(0.05),

                      border:
                          Border.all(

                        color:
                            Colors.white
                                .withOpacity(0.08),
                      ),
                    ),

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Container(

                          padding:
                              const EdgeInsets.all(18),

                          decoration:
                              const BoxDecoration(

                            shape: BoxShape.circle,

                            gradient:
                                LinearGradient(
                              colors: [
                                Colors.cyanAccent,
                                Colors.blueAccent,
                              ],
                            ),
                          ),

                          child: const Icon(

                            Icons.person_add_alt_1,

                            size: 42,

                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(

                          'Create Account',

                          style: TextStyle(

                            color: Colors.white,

                            fontSize: 34,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(

                          'Clinical Cyber AI Platform',

                          style: TextStyle(

                            color:
                                Colors.white
                                    .withOpacity(0.6),

                            fontSize: 15,
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
                              cyberInput(

                            hint: 'Username',

                            icon:
                                Icons.person_outline,
                          ),
                        ),

                        const SizedBox(height: 22),

                        // =========================
                        // PHONE
                        // =========================

                        TextField(

                          controller:
                              phoneController,

                          keyboardType:
                              TextInputType.phone,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              cyberInput(

                            hint: 'Phone Number',

                            icon:
                                Icons.phone_android,
                          ),
                        ),

                        const SizedBox(height: 22),

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
                              cyberInput(

                            hint: 'Password',

                            icon:
                                Icons.lock_outline,
                          ),
                        ),

                        const SizedBox(height: 34),

                        // =========================
                        // BUTTON
                        // =========================

                        SizedBox(

                          width: double.infinity,

                          height: 60,

                          child: ElevatedButton(

                            onPressed:
                                isLoading
                                    ? null
                                    : register,

                            style:
                                ElevatedButton.styleFrom(

                              backgroundColor:
                                  Colors.cyanAccent,

                              foregroundColor:
                                  Colors.black,

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                            ),

                            child: isLoading

                                ? const CircularProgressIndicator()

                                : const Text(

                                    'REGISTER',

                                    style: TextStyle(

                                      fontSize: 18,

                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextButton(

                          onPressed: () {

                            Navigator.pop(context);
                          },

                          child: Text(

                            'Already have account? Login',

                            style: TextStyle(

                              color:
                                  Colors.white
                                      .withOpacity(0.6),
                            ),
                          ),
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