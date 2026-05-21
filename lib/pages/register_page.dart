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

  bool isLoading = false;

  Future<void> register() async {

    setState(() {
      isLoading = true;
    });

    await AuthService.register(

      username:
          usernameController.text,

      password:
          passwordController.text,
    );

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
            Text('Register Success'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: Colors.black,
      ),

      body: Center(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(24),

          child: Container(

            padding:
                const EdgeInsets.all(24),

            decoration: BoxDecoration(

              color:
                  const Color(0xFF1E1E1E),

              borderRadius:
                  BorderRadius.circular(20),
            ),

            child: Column(

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                const Text(

                  'REGISTER',

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 32,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                TextField(

                  controller:
                      usernameController,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Username',

                    hintStyle:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),

                    filled: true,

                    fillColor:
                        Colors.black,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextField(

                  controller:
                      passwordController,

                  obscureText: true,

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(

                    hintText: 'Password',

                    hintStyle:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),

                    filled: true,

                    fillColor:
                        Colors.black,

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                              14),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(

                    onPressed:
                        isLoading
                            ? null
                            : register,

                    child: isLoading

                        ? const CircularProgressIndicator()

                        : const Text(

                            'REGISTER',

                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}