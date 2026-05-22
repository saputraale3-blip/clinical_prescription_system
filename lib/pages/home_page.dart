import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

import 'drug_database_page.dart';
import 'login_page.dart';
import 'pediatric_dose_page.dart';
import 'prescription_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);

    final isDark = themeProvider.isDarkMode;

    final width =
        MediaQuery.of(context).size.width;

    int crossAxisCount = 1;

    if (width > 1200) {
      crossAxisCount = 3;
    } else if (width > 700) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff071227)
          : const Color(0xffF4F7FB),

      body: SafeArea(
        child: Row(
          children: [

            // =========================
            // SIDEBAR
            // =========================

            if (width > 850)
              Container(
                width: 280,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff16243d)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(25),
                      ),

                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: Colors.cyanAccent,
                        size: 55,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'Clinical System',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 50),

                    buildMenuTile(
                      context,
                      icon: Icons.home_rounded,
                      title: 'Home',
                      isDark: isDark,
                    ),

                    buildMenuTile(
                      context,
                      icon:
                          Icons.medication_rounded,
                      title: 'Drug Database',
                      isDark: isDark,
                    ),

                    buildMenuTile(
                      context,
                      icon:
                          Icons.receipt_long_rounded,
                      title: 'Prescription',
                      isDark: isDark,
                    ),

                    buildMenuTile(
                      context,
                      icon:
                          Icons.child_care_rounded,
                      title: 'Pediatric Dose',
                      isDark: isDark,
                    ),

                    const Spacer(),

                    ListTile(
                      leading: Icon(
                        Icons.dark_mode_rounded,
                        color: isDark
                            ? Colors.white
                            : Colors.black87,
                      ),

                      title: Text(
                        'Theme',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),

                      trailing: Switch(
                        value: isDark,
                        onChanged: (value) {
                          themeProvider.toggleTheme();
                        },
                      ),
                    ),

                    ListTile(
                      leading: const Icon(
                        Icons.logout_rounded,
                        color: Colors.redAccent,
                      ),

                      title: const Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      ),

                      onTap: () async {
                        await AuthService.logout();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),

            // =========================
            // CONTENT
            // =========================

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.all(30),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // =========================
                    // HEADER
                    // =========================

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(35),

                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 12,
                          sigmaY: 12,
                        ),

                        child: Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets.all(
                            35,
                          ),

                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(
                              colors: [
                                Colors.cyanAccent
                                    .withOpacity(0.8),
                                Colors.blueAccent
                                    .withOpacity(0.7),
                              ],
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              35,
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              const Text(
                                'Welcome Back 👋',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                'Professional clinical prescription platform.',

                                style: TextStyle(
                                  color: Colors.white
                                      .withOpacity(0.95),

                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(
                                  height: 25),

                              Row(
                                children: [

                                  buildStatCard(
                                    title:
                                        'Prescriptions',
                                    value: '560',
                                  ),

                                  const SizedBox(
                                      width: 18),

                                  buildStatCard(
                                    title:
                                        'Drugs',
                                    value: '128',
                                  ),

                                  const SizedBox(
                                      width: 18),

                                  buildStatCard(
                                    title:
                                        'Users',
                                    value: '42',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 35),

                    Text(
                      'Quick Access',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black87,

                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    GridView.count(
                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                          crossAxisCount,

                      crossAxisSpacing: 25,

                      mainAxisSpacing: 25,

                      childAspectRatio: 1.1,

                      children: const [

                        ModernCard(
                          title:
                              'Drug Database',
                          subtitle:
                              'Browse medicines',
                          icon:
                              Icons.medication_rounded,
                          color: Colors.cyan,
                          page:
                              DrugDatabasePage(),
                        ),

                        ModernCard(
                          title:
                              'Pediatric Dose',
                          subtitle:
                              'Dose calculator',
                          icon:
                              Icons.child_care_rounded,
                          color: Colors.orange,
                          page:
                              PediatricDosePage(),
                        ),

                        ModernCard(
                          title:
                              'Prescription',
                          subtitle:
                              'Create prescriptions',
                          icon:
                              Icons.receipt_long_rounded,
                          color: Colors.green,
                          page:
                              PrescriptionPage(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 6,
      ),

      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(18),
        ),

        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.cyanAccent,
          ),

          title: Text(
            title,
            style: TextStyle(
              color: isDark
                  ? Colors.white
                  : Colors.black87,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatCard({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(0.18),

          borderRadius:
              BorderRadius.circular(20),
        ),

        child: Column(
          children: [

            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModernCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;

  const ModernCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  State<ModernCard> createState() =>
      _ModernCardState();
}

class _ModernCardState
    extends State<ModernCard> {

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
              builder: (_) => widget.page,
            ),
          );
        },

        child: AnimatedContainer(

          duration:
              const Duration(
            milliseconds: 250,
          ),

          transform:
              Matrix4.identity()

                ..translate(
                  0.0,
                  isHover ? -8.0 : 0.0,
                ),

          decoration: BoxDecoration(

            gradient:
                LinearGradient(

              colors: [

                widget.color,

                widget.color
                    .withOpacity(0.7),
              ],
            ),

            borderRadius:
                BorderRadius.circular(35),

            boxShadow: [

              BoxShadow(
                color: widget.color
                    .withOpacity(0.35),

                blurRadius: 25,

                offset:
                    const Offset(0, 14),
              ),
            ],
          ),

          child: Padding(

            padding:
                const EdgeInsets.all(28),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(

                  padding:
                      const EdgeInsets.all(
                    16,
                  ),

                  decoration: BoxDecoration(

                    color:
                        Colors.white
                            .withOpacity(0.2),

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Icon(
                    widget.icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ),

                const Spacer(),

                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  widget.subtitle,
                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.9),
                    fontSize: 15,
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