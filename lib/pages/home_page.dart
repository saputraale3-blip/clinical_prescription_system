import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

import 'drug_database_page.dart';
import 'login_page.dart';
import 'pediatric_dose_page.dart';
import 'prescription_page.dart';

class HomePage extends StatelessWidget {

  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context)
            .size
            .width;

    int crossAxisCount = 2;

    if (width > 1200) {

      crossAxisCount = 4;
    }

    else if (width > 800) {

      crossAxisCount = 3;
    }

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          'Clinical Prescription',
        ),

        actions: [

          // THEME BUTTON

          IconButton(

            onPressed: () {

              Provider.of<ThemeProvider>(

                context,

                listen: false,
              ).toggleTheme();
            },

            icon: const Icon(
              Icons.dark_mode_rounded,
            ),
          ),

          // LOGOUT

          IconButton(

            onPressed: () async {

              await AuthService.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder:
                      (_) =>
                          const LoginPage(),
                ),

                (route) => false,
              );
            },

            icon: const Icon(
              Icons.logout_rounded,
            ),
          ),
        ],
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // HEADER

            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(
                28,
              ),

              decoration:
                  BoxDecoration(

                gradient:
                    const LinearGradient(

                  colors: [

                    Color(0xFF14B8A6),

                    Color(0xFF0F766E),
                  ],
                ),

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),

              child: const Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    'Welcome Back 👋',

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 30,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(

                    'Access prescriptions and clinical tools easily.',

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              'Quick Access',

              style: TextStyle(

                fontSize: 24,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(

              child:
                  GridView.count(

                crossAxisCount:
                    crossAxisCount,

                crossAxisSpacing:
                    20,

                mainAxisSpacing:
                    20,

                childAspectRatio:
                    1.05,

                children: const [

                  AnimatedUserCard(

                    title:
                        'Drug Database',

                    subtitle:
                        'Browse medicine database',

                    icon:
                        Icons.medication_rounded,

                    color:
                        Colors.cyan,

                    page:
                        DrugDatabasePage(),
                  ),

                  AnimatedUserCard(

                    title:
                        'Pediatric Dose',

                    subtitle:
                        'Child dosage calculator',

                    icon:
                        Icons.child_care_rounded,

                    color:
                        Colors.orange,

                    page:
                        PediatricDosePage(),
                  ),

                  AnimatedUserCard(

                    title:
                        'Prescription',

                    subtitle:
                        'Create prescriptions easily',

                    icon:
                        Icons.receipt_long_rounded,

                    color:
                        Colors.green,

                    page:
                        PrescriptionPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================
// ANIMATED USER CARD
// =====================================

class AnimatedUserCard
    extends StatefulWidget {

  final String title;

  final String subtitle;

  final IconData icon;

  final Color color;

  final Widget page;

  const AnimatedUserCard({

    super.key,

    required this.title,

    required this.subtitle,

    required this.icon,

    required this.color,

    required this.page,
  });

  @override
  State<AnimatedUserCard>
      createState() =>
          _AnimatedUserCardState();
}

class _AnimatedUserCardState
    extends State<AnimatedUserCard> {

  bool isHover = false;

  @override
  Widget build(BuildContext context) {

    return MouseRegion(

      onEnter: (_) {

        setState(() {
          isHover = true;
        });
      },

      onExit: (_) {

        setState(() {
          isHover = false;
        });
      },

      child: GestureDetector(

        onTap: () {

          Navigator.push(

            context,

            MaterialPageRoute(

              builder:
                  (_) =>
                      widget.page,
            ),
          );
        },

        child:
            AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 250,
          ),

          curve:
              Curves.easeInOut,

          transform:
              Matrix4.identity()

                ..scale(
                  isHover
                      ? 1.03
                      : 1.0,
                )

                ..translate(
                  0.0,
                  isHover
                      ? -8.0
                      : 0.0,
                ),

          decoration:
              BoxDecoration(

            gradient:
                LinearGradient(

              colors: [

                widget.color
                    .withOpacity(
                  0.9,
                ),

                widget.color
                    .withOpacity(
                  0.6,
                ),
              ],

              begin:
                  Alignment.topLeft,

              end:
                  Alignment.bottomRight,
            ),

            borderRadius:
                BorderRadius.circular(
              30,
            ),

            boxShadow: [

              BoxShadow(

                color:
                    widget.color
                        .withOpacity(
                  isHover
                      ? 0.5
                      : 0.25,
                ),

                blurRadius:
                    isHover
                        ? 30
                        : 14,

                offset:
                    Offset(
                  0,
                  isHover
                      ? 14
                      : 8,
                ),
              ),
            ],
          ),

          child: Padding(

            padding:
                const EdgeInsets.all(
              22,
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                AnimatedContainer(

                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration:
                      BoxDecoration(

                    color:
                        Colors.white
                            .withOpacity(
                      isHover
                          ? 0.28
                          : 0.18,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Icon(

                    widget.icon,

                    color:
                        Colors.white,

                    size: 34,
                  ),
                ),

                const Spacer(),

                Text(

                  widget.title,

                  style:
                      const TextStyle(

                    color:
                        Colors.white,

                    fontSize: 22,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(

                  widget.subtitle,

                  style:
                      TextStyle(

                    color:
                        Colors.white
                            .withOpacity(
                      0.92,
                    ),

                    fontSize: 14,
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