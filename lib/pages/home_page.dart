import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

import 'drug_database_page.dart';
import 'login_page.dart';
import 'pediatric_dose_page.dart';
import 'prescription_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> pages = [
    const DashboardContent(),
    const DrugDatabasePage(),
    const PediatricDosePage(),
    const PrescriptionPage(),
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
  ];

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool isMobile =
        width < 900;

    return Scaffold(
      backgroundColor:
          const Color(0xff050816),

      drawer:
          isMobile
              ? Drawer(
                  backgroundColor:
                      const Color(
                    0xff0d1324,
                  ),
                  child:
                      buildSidebar(
                    true,
                  ),
                )
              : null,

      appBar:
          isMobile
              ? AppBar(
                  elevation: 0,
                  backgroundColor:
                      Colors
                          .transparent,
                  title:
                      const Text(
                    'Clinical System',
                    style: TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Provider.of<
                            ThemeProvider>(
                          context,
                          listen:
                              false,
                        ).toggleTheme();
                      },
                      icon: const Icon(
                        Icons
                            .dark_mode_rounded,
                      ),
                    ),
                  ],
                )
              : null,

      body: Stack(
        children: [
          // BACKGROUND

          Container(
            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment
                        .topLeft,
                end:
                    Alignment
                        .bottomRight,
                colors: [
                  Color(
                    0xff020617,
                  ),
                  Color(
                    0xff071227,
                  ),
                  Color(
                    0xff0b1e3f,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    Colors
                        .cyanAccent
                        .withOpacity(
                  0.05,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -150,
            left: -120,
            child: Container(
              width: 340,
              height: 340,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                color:
                    Colors
                        .blueAccent
                        .withOpacity(
                  0.05,
                ),
              ),
            ),
          ),

          Row(
            children: [
              if (!isMobile)
                Container(
                  width: 290,
                  margin:
                      const EdgeInsets.all(
                    18,
                  ),
                  child:
                      ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                    child:
                        BackdropFilter(
                      filter:
                          ImageFilter.blur(
                        sigmaX: 10,
                        sigmaY: 10,
                      ),
                      child:
                          Container(
                        decoration:
                            BoxDecoration(
                          color:
                              Colors
                                  .white
                                  .withOpacity(
                            0.05,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                          border:
                              Border.all(
                            color:
                                Colors
                                    .white
                                    .withOpacity(
                              0.08,
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
                    IndexedStack(
                  index:
                      selectedIndex,
                  children: pages,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSidebar(
    bool isMobile,
  ) {
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
                color: Colors
                    .cyanAccent
                    .withOpacity(
                  0.30,
                ),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Icon(
            Icons
                .local_hospital_rounded,
            size: 42,
            color: Colors.white,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        const Text(
          'Clinical System',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 6,
        ),

        Text(
          'Cyber Dashboard',
          style: TextStyle(
            color:
                Colors.white
                    .withOpacity(
              0.55,
            ),
            fontSize: 14,
          ),
        ),

        const SizedBox(
          height: 40,
        ),

        Expanded(
          child: ListView.builder(
            itemCount: menu.length,
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
                  vertical: 7,
                ),
                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 150,
                  ),
                  decoration:
                      BoxDecoration(
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
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    boxShadow:
                        selected
                            ? [
                                BoxShadow(
                                  color: Colors
                                      .cyanAccent
                                      .withOpacity(
                                    0.18,
                                  ),
                                  blurRadius:
                                      16,
                                ),
                              ]
                            : [],
                  ),
                  child: ListTile(
                    dense: true,
                    leading: Icon(
                      item['icon'],
                      color:
                          Colors.white,
                    ),
                    title: Text(
                      item['title'],
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
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

                      if (isMobile) {
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

        const Divider(
          color: Colors.white12,
        ),

        ListTile(
          leading: const Icon(
            Icons.dark_mode_rounded,
            color: Colors.white,
          ),
          title: const Text(
            'Theme',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () {
            Provider.of<
                ThemeProvider>(
              context,
              listen: false,
            ).toggleTheme();
          },
        ),

        ListTile(
          leading: const Icon(
            Icons.logout_rounded,
            color: Colors.white,
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onTap: () async {
            await AuthService.logout();

            if (!mounted) return;

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
        ),

        const SizedBox(
          height: 16,
        ),
      ],
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
    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool isMobile =
        width < 700;

    int crossAxisCount = 2;

    if (width > 1400) {
      crossAxisCount = 4;
    } else if (width > 900) {
      crossAxisCount = 3;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        isMobile ? 18 : 28,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              35,
            ),
            child: BackdropFilter(
              filter:
                  ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.all(
                  isMobile
                      ? 24
                      : 38,
                ),
                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    35,
                  ),
                  color:
                      Colors.white
                          .withOpacity(
                    0.05,
                  ),
                  border: Border.all(
                    color:
                        Colors.white
                            .withOpacity(
                      0.08,
                    ),
                  ),
                ),
                child:
                    isMobile
                        ? buildMobileHero()
                        : buildDesktopHero(),
              ),
            ),
          ),

          const SizedBox(
            height: 35,
          ),

          const Text(
            'Analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            'Realtime cyber analytics',
            style: TextStyle(
              color:
                  Colors.white
                      .withOpacity(
                0.6,
              ),
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          GridView.count(
            crossAxisCount:
                crossAxisCount,
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            crossAxisSpacing:
                18,
            mainAxisSpacing: 18,
            childAspectRatio:
                isMobile
                    ? 1.25
                    : 1.30,
            children: const [
              DashboardCard(
                title:
                    'Total Drugs',
                value: '128',
                icon: Icons
                    .medication_rounded,
                color: Colors.cyan,
              ),
              DashboardCard(
                title: 'Patients',
                value: '542',
                icon: Icons
                    .people_alt_rounded,
                color: Colors.orange,
              ),
              DashboardCard(
                title:
                    'Prescriptions',
                value: '1,240',
                icon: Icons
                    .receipt_long_rounded,
                color: Colors.green,
              ),
              DashboardCard(
                title:
                    'Clinical Notes',
                value: '84',
                icon: Icons
                    .note_alt_rounded,
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDesktopHero() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              const Text(
                'Clinical Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              Text(
                'Modern healthcare cyber management system.',
                style: TextStyle(
                  color:
                      Colors.white
                          .withOpacity(
                    0.75,
                  ),
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  quickButton(
                    icon:
                        Icons.add_rounded,
                    title:
                        'Prescription',
                  ),
                  quickButton(
                    icon: Icons
                        .search_rounded,
                    title:
                        'Find Drug',
                  ),
                  quickButton(
                    icon: Icons
                        .people_alt_rounded,
                    title:
                        'Patients',
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(
          width: 20,
        ),

        Container(
          width: 180,
          height: 180,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            color:
                Colors.cyanAccent
                    .withOpacity(
              0.08,
            ),
          ),
          child: const Icon(
            Icons
                .local_hospital_rounded,
            size: 120,
            color: Colors.white24,
          ),
        ),
      ],
    );
  }

  Widget buildMobileHero() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        Text(
          'Modern healthcare cyber management system.',
          style: TextStyle(
            color:
                Colors.white
                    .withOpacity(
              0.75,
            ),
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            quickButton(
              icon:
                  Icons.add_rounded,
              title:
                  'Prescription',
            ),
            quickButton(
              icon:
                  Icons.search_rounded,
              title:
                  'Find Drug',
            ),
          ],
        ),
      ],
    );
  }
}

Widget quickButton({
  required IconData icon,
  required String title,
}) {
  return Container(
    padding:
        const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 14,
    ),
    decoration:
        BoxDecoration(
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      border: Border.all(
        color:
            Colors.cyanAccent
                .withOpacity(
          0.35,
        ),
      ),
      color:
          Colors.white.withOpacity(
        0.04,
      ),
    ),
    child: Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),

        const SizedBox(
          width: 10,
        ),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class DashboardCard
    extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  State<DashboardCard>
      createState() =>
          _DashboardCardState();
}

class _DashboardCardState
    extends State<DashboardCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context)
            .size
            .width <
        700;

    return MouseRegion(
      onEnter: (_) {
        if (!isMobile) {
          setState(() {
            hover = true;
          });
        }
      },
      onExit: (_) {
        if (!isMobile) {
          setState(() {
            hover = false;
          });
        }
      },
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),
        transform:
            Matrix4.identity()
              ..scale(
                hover ? 1.02 : 1,
              ),
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment
                    .bottomRight,
            colors: [
              widget.color
                  .withOpacity(
                0.85,
              ),
              widget.color
                  .withOpacity(
                0.45,
              ),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.color
                  .withOpacity(
                0.16,
              ),
              blurRadius: 22,
              offset:
                  const Offset(
                0,
                10,
              ),
            ),
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.all(
            24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.all(
                      14,
                    ),
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .white
                          .withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      color:
                          Colors.white,
                      size: 30,
                    ),
                  ),

                  const Spacer(),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,
                    children: [
                      Text(
                        '+12.5%',
                        style:
                            TextStyle(
                          color: Colors
                              .greenAccent
                              .shade100,
                          fontWeight:
                              FontWeight
                                  .bold,
                          fontSize:
                              isMobile
                                  ? 14
                                  : 18,
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        'vs last month',
                        style:
                            TextStyle(
                          color: Colors
                              .white
                              .withOpacity(
                            0.6,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              Text(
                widget.value,
                maxLines: 1,
                overflow:
                    TextOverflow
                        .ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                  fontSize:
                      isMobile
                          ? 28
                          : 44,
                  height: 1,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                widget.title,
                maxLines: 1,
                overflow:
                    TextOverflow
                        .ellipsis,
                style: TextStyle(
                  color:
                      Colors.white
                          .withOpacity(
                    0.85,
                  ),
                  fontSize:
                      isMobile
                          ? 15
                          : 18,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}