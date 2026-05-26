import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

import 'drug_database_page.dart';
import 'login_page.dart';
import 'pediatric_dose_page.dart';
import 'prescription_page.dart';
import 'ai_clinical_assistant_page.dart';
import 'ai_chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  int selectedIndex = 0;

  bool isDark(BuildContext context) {
    return Theme.of(context)
            .brightness ==
        Brightness.dark;
  }

  final List<Widget> pages = [
    const DashboardContent(),
    const DrugDatabasePage(),
    const PediatricDosePage(),
    const PrescriptionPage(),
    const AIClinicalAssistantPage(),
    const AIChatPage(),
  ];

  final List<Map<String, dynamic>>
      menu = [
    {
      'title': 'Dashboard',
      'icon': Icons.dashboard_rounded,
    },
    {
      'title': 'Drug Database',
      'icon':
          Icons.medication_rounded,
    },
    {
      'title': 'Pediatric Dose',
      'icon':
          Icons.child_care_rounded,
    },
    {
      'title': 'Prescription',
      'icon':
          Icons.receipt_long_rounded,
    },
    {
      'title': 'AI Assistant',
      'icon': Icons.auto_awesome_rounded,
    },
    {
      'title': 'AI Chat',
      'icon': Icons.smart_toy_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool mobile =
        width < 900;

    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark
          ? const Color(0xff030712)
          : const Color(0xffeef4fb),

      drawer: mobile
          ? Drawer(
              backgroundColor: dark
                  ? const Color(
                      0xff071120)
                  : Colors.white,
              child:
                  buildSidebar(true),
            )
          : null,

      appBar: mobile
          ? AppBar(
              elevation: 0,
              backgroundColor:
                  Colors.transparent,
              title: Text(
                'Clinical Cyber',
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  color: dark
                      ? Colors.white
                      : const Color(
                          0xff0f172a,
                        ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Provider.of<ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                  icon: Icon(
                    dark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: dark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            )
          : null,

      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topLeft,
                end:
                    Alignment.bottomRight,
                colors: dark
                    ? [
                        const Color(
                          0xff020617,
                        ),
                        const Color(
                          0xff071227,
                        ),
                        const Color(
                          0xff0a1931,
                        ),
                      ]
                    : [
                        const Color(
                          0xfff8fbff,
                        ),
                        const Color(
                          0xffeef4fb,
                        ),
                        const Color(
                          0xffdde8f5,
                        ),
                      ],
              ),
            ),
          ),

          Positioned(
            top: -140,
            right: -100,
            child: cyberOrb(
              340,
              Colors.cyanAccent,
            ),
          ),

          Positioned(
            bottom: -180,
            left: -120,
            child: cyberOrb(
              420,
              Colors.blueAccent,
            ),
          ),

          Positioned(
            top: 280,
            left: 200,
            child: cyberOrb(
              180,
              Colors.purpleAccent,
            ),
          ),

          Row(
            children: [
              if (!mobile)
                Container(
                  width: 300,
                  margin:
                      const EdgeInsets.all(
                    18,
                  ),
                  child:
                      ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      32,
                    ),
                    child:
                        BackdropFilter(
                      filter:
                          ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20,
                      ),
                      child:
                          Container(
                        decoration:
                            BoxDecoration(
                          color: dark
                              ? Colors.white
                                  .withOpacity(
                                  0.05,
                                )
                              : Colors.white
                                  .withOpacity(
                                  0.75,
                                ),
                          borderRadius:
                              BorderRadius.circular(
                            32,
                          ),
                          border:
                              Border.all(
                            color: dark
                                ? Colors
                                    .cyanAccent
                                    .withOpacity(
                                    0.15,
                                  )
                                : Colors.blue
                                    .withOpacity(
                                    0.10,
                                  ),
                          ),
                        ),
                        child:
                            buildSidebar(
                          false,
                        ),
                      ),
                    ),
                  ),
                ),

              Expanded(
                child:
                    AnimatedSwitcher(
                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),
                  child:
                      IndexedStack(
                    key: ValueKey(
                      selectedIndex,
                    ),
                    index:
                        selectedIndex,
                    children: pages,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSidebar(
    bool mobile,
  ) {
    final dark = isDark(context);

    return Column(
      children: [
        const SizedBox(
          height: 45,
        ),

        Container(
          padding:
              const EdgeInsets.all(
            20,
          ),
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            gradient:
                const LinearGradient(
              colors: [
                Colors.cyanAccent,
                Colors.blueAccent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.cyanAccent
                        .withOpacity(
                  0.45,
                ),
                blurRadius: 30,
              ),
            ],
          ),
          child: const Icon(
            Icons
                .local_hospital_rounded,
            size: 44,
            color: Colors.white,
          ),
        ),

        const SizedBox(
          height: 22,
        ),

        Text(
          'Clinical Cyber',
          style: TextStyle(
            color: dark
                ? Colors.white
                : const Color(
                    0xff0f172a,
                  ),
            fontSize: 28,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Text(
          'AI Medical Dashboard',
          style: TextStyle(
            color: dark
                ? Colors.white
                    .withOpacity(
                    0.55,
                  )
                : Colors.black54,
          ),
        ),

        const SizedBox(
          height: 40,
        ),

        Expanded(
          child: ListView.builder(
            itemCount:
                menu.length,
            itemBuilder:
                (context, index) {
              final item =
                  menu[index];

              final bool selected =
                  selectedIndex ==
                      index;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 220,
                  ),
                  decoration:
                      BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                    gradient:
                        selected
                            ? const LinearGradient(
                                colors: [
                                  Color(
                                    0xff22d3ee,
                                  ),
                                  Color(
                                    0xff2563eb,
                                  ),
                                ],
                              )
                            : null,
                    color:
                        selected
                            ? null
                            : Colors
                                .transparent,
                  ),
                  child:
                      ListTile(
                    dense: true,
                    leading:
                        Container(
                      padding:
                          const EdgeInsets.all(
                        10,
                      ),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        color:
                            Colors
                                .white
                                .withOpacity(
                          selected
                              ? 0.15
                              : dark
                                  ? 0.10
                                  : 0.80,
                        ),
                      ),
                      child: Icon(
                        item['icon'],
                        color: selected
                            ? Colors.white
                            : dark
                                ? Colors.white
                                : const Color(
                                    0xff0f172a,
                                  ),
                      ),
                    ),
                    title: Text(
                      item['title'],
                      style:
                          TextStyle(
                        color: selected
                            ? Colors.white
                            : dark
                                ? Colors.white
                                : const Color(
                                    0xff0f172a,
                                  ),
                        fontWeight:
                            FontWeight
                                .w600,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex =
                            index;
                      });

                      if (mobile) {
                        Navigator.pop(
                          context,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),

        Divider(
          color: dark
              ? Colors.white12
              : Colors.black12,
        ),

        ListTile(
          leading: Icon(
            dark
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: dark
                ? Colors.white
                : Colors.black,
          ),
          title: Text(
            dark
                ? 'Light Mode'
                : 'Dark Mode',
            style: TextStyle(
              color: dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          onTap: () {
            Provider.of<ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme();
          },
        ),

        ListTile(
          leading: Icon(
            Icons.logout_rounded,
            color: dark
                ? Colors.white
                : Colors.black,
          ),
          title: Text(
            'Logout',
            style: TextStyle(
              color: dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          onTap: () async {
            await AuthService.logout();

            if (!mounted) return;

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

        const SizedBox(
          height: 18,
        ),
      ],
    );
  }

  Widget cyberOrb(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            color.withOpacity(0.08),
      ),
    );
  }
}

class DashboardContent
    extends StatelessWidget {
  const DashboardContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    return Center(
      child: Text(
        'Clinical Prescription System',
        style: TextStyle(
          fontSize: 32,
          fontWeight:
              FontWeight.bold,
          color: dark
              ? Colors.white
              : const Color(
                  0xff0f172a,
                ),
        ),
      ),
    );
  }
}
