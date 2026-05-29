import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/theme_provider.dart';

import 'drug_database_page.dart';
import 'pediatric_dose_page.dart';
import 'prescription_page.dart';
import 'ai_clinical_assistant_page.dart';
import 'ai_chat_page.dart';
import 'login_page.dart';
import 'upgrade_page.dart';

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
      'icon':
          Icons.auto_awesome_rounded,
    },
    {
      'title': 'AI Chat',
      'icon':
          Icons.smart_toy_rounded,
    },
  ];

  Widget cyberOrb({
    required Color color,
    required double size,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.35),
            color.withOpacity(0.02),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool mobile =
        width < 900;

    final dark = isDark(context);

    final username =
    AuthService.currentUsername ??
    'Guest';

    final role =
        AuthService.currentRole ??
            'basic';

    return Scaffold(

      backgroundColor: dark
          ? const Color(0xff030712)
          : const Color(0xffeef4fb),

      drawer: mobile
          ? Drawer(
              backgroundColor: dark
                  ? const Color(
                      0xff071120,
                    )
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
              title: const Text(
                'Clinical Cyber',
              ),
              actions: [

                IconButton(
                  onPressed: () {
                    Provider.of<
                        ThemeProvider>(
                      context,
                      listen: false,
                    ).toggleTheme();
                  },
                  icon: Icon(
                    dark
                        ? Icons
                            .light_mode_rounded
                        : Icons
                            .dark_mode_rounded,
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                  onPressed: () async {

                    await AuthService
                        .logout();

                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) =>
                                  const LoginPage(),
                        ),
                      );
                    }
                  },
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
              color:
                  Colors.cyanAccent,
              size: 340,
            ),
          ),

          Positioned(
            bottom: -180,
            left: -120,
            child: cyberOrb(
              color:
                  Colors.blueAccent,
              size: 420,
            ),
          ),

          Positioned(
            top: 280,
            left: 200,
            child: cyberOrb(
              color:
                  Colors.purpleAccent,
              size: 180,
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
                child: Column(
                  children: [

                    if (!mobile)
                      Container(
                        margin:
                            const EdgeInsets.only(
                          top: 20,
                          right: 20,
                          left: 10,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                          color: dark
                              ? Colors.white
                                  .withOpacity(
                                  0.05,
                                )
                              : Colors.white
                                  .withOpacity(
                                  0.80,
                                ),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [

                            Text(
                              'Clinical Cyber AI',
                              style: TextStyle(
                                color: dark
                                    ? Colors.white
                                    : const Color(
                                        0xff0f172a,
                                      ),
                                fontSize: 24,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Row(
                              children: [

                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [

                                    Text(
                                      username,
                                      style: TextStyle(
                                        color: dark
                                            ? Colors.white
                                            : const Color(
                                                0xff0f172a,
                                              ),
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration:
                                          BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(
                                          14,
                                        ),
                                        gradient:
                                            const LinearGradient(
                                          colors: [
                                            Colors.cyanAccent,
                                            Colors.blueAccent,
                                          ],
                                        ),
                                      ),
                                      child: Text(
                                        role.toUpperCase(),
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 11,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  width: 18,
                                ),

                                IconButton(
                                  onPressed: () {
                                    Provider.of<
                                        ThemeProvider>(
                                      context,
                                      listen: false,
                                    ).toggleTheme();
                                  },
                                  icon: Icon(
                                    dark
                                        ? Icons
                                            .light_mode_rounded
                                        : Icons
                                            .dark_mode_rounded,
                                    color: dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.logout_rounded,
                                  ),
                                  onPressed: () async {

                                    await AuthService
                                        .logout();

                                    if (mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  const LoginPage(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
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

    final dark =
        isDark(context);

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
                ? Colors.white70
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
                  ),

                  child:
                      ListTile(

                    dense: true,

                    leading:
                        Icon(
                      item['icon'],
                      color: selected
                          ? Colors.white
                          : dark
                              ? Colors.white
                              : const Color(
                                  0xff0f172a,
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
                            FontWeight.w600,
                      ),
                    ),

                    onTap: () {

                      if (AuthService.isUserTrialExpired()) {

  ScaffoldMessenger.of(
    context,
  ).showSnackBar(

    const SnackBar(
      content: Text(
        'Trial expired. Please upgrade.',
      ),
    ),
  );

  Navigator.push(
    context,

    MaterialPageRoute(
      builder:
          (_) => const UpgradePage(),
    ),
  );

  return;
}

                      final role =
                          AuthService.currentRole;

                      if ((item['title'] ==
                                  'AI Assistant' ||
                              item['title'] ==
                                  'AI Chat') &&
                          role ==
                              'basic') {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Upgrade to PRO to access AI features',
                            ),
                          ),
                        );

                        return;
                      }

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
      ],
    );
  }
}

class DashboardContent extends StatelessWidget {

  const DashboardContent({
    super.key,
  });

  bool isDark(BuildContext context) {
    return Theme.of(context).brightness ==
        Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {

    final dark = isDark(context);

    final username =
        AuthService.currentUsername ??
            'Guest';

    final role =
        AuthService.currentRole;

    return SingleChildScrollView(

      padding:
          const EdgeInsets.all(26),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // =====================================================
          // PREMIUM HEADER
          // =====================================================

          ClipRRect(

            borderRadius:
                BorderRadius.circular(34),

            child: BackdropFilter(

              filter: ImageFilter.blur(

                sigmaX: 14,
                sigmaY: 14,
              ),

              child: Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(32),

                decoration:
                    BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(34),

                  gradient:
                      LinearGradient(

                    begin:
                        Alignment.topLeft,

                    end:
                        Alignment.bottomRight,

                    colors: [

                      const Color(0xff6ee7b7)
                          .withOpacity(0.28),

                      const Color(0xff60a5fa)
                          .withOpacity(0.22),

                      const Color(0xff1e3a8a)
                          .withOpacity(0.18),
                    ],
                  ),

                  border: Border.all(

                    color:
                        Colors.white
                            .withOpacity(
                      0.08,
                    ),
                  ),

                  boxShadow: [

                    BoxShadow(

                      color:
                          Colors.cyanAccent
                              .withOpacity(
                        0.06,
                      ),

                      blurRadius: 28,

                      spreadRadius: 1,
                    ),
                  ],
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(

                      children: [

                        Container(

                          padding:
                              const EdgeInsets.all(
                            16,
                          ),

                          decoration:
                              BoxDecoration(

                            shape:
                                BoxShape.circle,

                            color:
                                Colors.white
                                    .withOpacity(
                              0.16,
                            ),
                          ),

                          child: const Icon(

                            Icons.local_hospital,

                            color:
                                Colors.white,

                            size: 40,
                          ),
                        ),

                        const SizedBox(
                          width: 20,
                        ),

                        Expanded(

                          child: Column(

                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(

                                'Welcome Back,',

                                style:
                                    TextStyle(

                                  color:
                                      Colors.white
                                          .withOpacity(
                                    0.82,
                                  ),

                                  fontSize: 18,
                                ),
                              ),

                              const SizedBox(
                                height: 6,
                              ),

                              Text(

                                username,

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize: 34,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(

                          padding:
                              const EdgeInsets.symmetric(

                            horizontal: 18,

                            vertical: 10,
                          ),

                          decoration:
                              BoxDecoration(

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),

                            color:
                                Colors.white
                                    .withOpacity(
                              0.14,
                            ),
                          ),

                          child: Text(

                            role.toUpperCase(),

                            style:
                                const TextStyle(

                              color:
                                  Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 28,
                    ),

                    Text(

                      'Modern AI-powered medical clinical system with futuristic cyber dashboard.',

                      style: TextStyle(

                        color:
                            Colors.white
                                .withOpacity(
                          0.82,
                        ),

                        height: 1.7,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 28,
          ),

          // =====================================================
          // STATS
          // =====================================================

          GridView.count(

            crossAxisCount: 2,

            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 18,

            mainAxisSpacing: 18,

            childAspectRatio: 1.5,

            children: [

              buildStatCard(

                title:
                    'Drug Database',

                value: 'Ready',

                icon:
                    Icons.medication_rounded,

                color:
                    Colors.cyanAccent,

                dark: dark,
              ),

              buildStatCard(

                title:
                    'Pediatric Dose',

                value: 'Ready',

                icon:
                    Icons.child_care_rounded,

                color:
                    Colors.orangeAccent,

                dark: dark,
              ),

              buildStatCard(

                title:
                    'AI Usage',

                value:
                    role == 'pro'
                        ? '0 / 30'
                        : 'LOCKED',

                icon:
                    Icons.auto_awesome,

                color:
                    Colors.purpleAccent,

                dark: dark,
              ),

              buildStatCard(

                title:
                    'Membership',

                value:
                    role.toUpperCase(),

                icon:
                    Icons.workspace_premium,

                color:
                    Colors.greenAccent,

                dark: dark,
              ),
            ],
          ),

          const SizedBox(
            height: 30,
          ),

          // =====================================================
          // MEMBERSHIP CARD
          // =====================================================

          buildMembershipCard(
            context,
            role,
          ),

          const SizedBox(
            height: 30,
          ),

          // =====================================================
          // QUICK ACTION
          // =====================================================

          Text(

            'Quick Actions',

            style: TextStyle(

              color: dark
                  ? Colors.white
                  : Colors.black,

              fontSize: 24,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          GridView.count(

            crossAxisCount: 2,

            shrinkWrap: true,

            physics:
                const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 18,

            mainAxisSpacing: 18,

            childAspectRatio: 1.15,

            children: [

              buildActionCard(

                title:
                    'AI Chat',

                icon:
                    Icons.smart_toy_rounded,

                color:
                    Colors.cyanAccent,
              ),

              buildActionCard(

                title:
                    'Drug Search',

                icon:
                    Icons.search_rounded,

                color:
                    Colors.orangeAccent,
              ),

              buildActionCard(

                title:
                    'Prescription',

                icon:
                    Icons.receipt_long_rounded,

                color:
                    Colors.greenAccent,
              ),

              buildActionCard(

                title:
                    'Pediatric',

                icon:
                    Icons.child_care_rounded,

                color:
                    Colors.purpleAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // STAT CARD
  // =====================================================

  Widget buildStatCard({

    required String title,

    required String value,

    required IconData icon,

    required Color color,

    required bool dark,

  }) {

    return Container(

      padding:
          const EdgeInsets.all(22),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        color: dark
            ? Colors.white
                .withOpacity(0.05)
            : Colors.white,

        border: Border.all(

          color:
              Colors.white
                  .withOpacity(0.08),
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Container(

            padding:
                const EdgeInsets.all(
              12,
            ),

            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

              color:
                  color.withOpacity(
                0.15,
              ),
            ),

            child: Icon(

              icon,

              color: color,
            ),
          ),

          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Text(

                value,

                style: TextStyle(

                  color: dark
                      ? Colors.white
                      : Colors.black,

                  fontSize: 26,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(

                title,

                style: TextStyle(

                  color: dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================
  // MEMBERSHIP CARD
  // =====================================================

  Widget buildMembershipCard(
    BuildContext context,
    String role,
  ) {

    if (role == 'user') {

      return Container(

        width: double.infinity,

        padding:
            const EdgeInsets.all(
          28,
        ),

        decoration:
            BoxDecoration(

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          gradient:
              const LinearGradient(

            colors: [

              Color(0xff7c2d12),

              Color(0xff9a3412),
            ],
          ),
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(

              'TRIAL ACTIVE',

              style: TextStyle(

                color:
                    Colors.orangeAccent,

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(

              'Upgrade to continue using premium medical system.',

              style: TextStyle(

                color: Colors.white,

                height: 1.7,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(

              width: double.infinity,

              height: 56,

              child: ElevatedButton(

                onPressed: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder:
                          (_) =>
                              const UpgradePage(),
                    ),
                  );
                },

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      Colors.orangeAccent,

                  foregroundColor:
                      Colors.black,
                ),

                child: const Text(
                  'Upgrade Membership',
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (role == 'basic') {

      return Container(

        width: double.infinity,

        padding:
            const EdgeInsets.all(
          28,
        ),

        decoration:
            BoxDecoration(

          borderRadius:
              BorderRadius.circular(
            28,
          ),

          gradient:
              const LinearGradient(

            colors: [

              Color(0xff172554),

              Color(0xff1e293b),
            ],
          ),
        ),

        child: const Text(

          'BASIC PLAN ACTIVE',

          style: TextStyle(

            color: Colors.white,

            fontSize: 24,

            fontWeight:
                FontWeight.bold,
          ),
        ),
      );
    }

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        gradient:
            const LinearGradient(

          colors: [

            Color(0xff064e3b),

            Color(0xff065f46),
          ],
        ),
      ),

      child: const Text(

        'PRO MEMBERSHIP ACTIVE',

        style: TextStyle(

          color: Colors.white,

          fontSize: 24,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  // =====================================================
  // ACTION CARD
  // =====================================================

  Widget buildActionCard({

    required String title,

    required IconData icon,

    required Color color,

  }) {

    return Container(

      padding:
          const EdgeInsets.all(
        22,
      ),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        color:
            Colors.white
                .withOpacity(
          0.05,
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          Container(

            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

              color:
                  color.withOpacity(
                0.15,
              ),
            ),

            child: Icon(

              icon,

              color: color,
            ),
          ),

          Text(

            title,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 20,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
