import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:clinical_prescription_system/pages/add_drug_page.dart';
import 'package:clinical_prescription_system/pages/admin_drug_management_page.dart';
import 'package:clinical_prescription_system/pages/drug_database_page.dart';
import 'package:clinical_prescription_system/pages/login_page.dart';
import 'package:clinical_prescription_system/pages/pediatric_dose_page.dart';
import 'package:clinical_prescription_system/pages/user_management_page.dart';

import 'package:clinical_prescription_system/services/auth_service.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() =>
      _AdminDashboardPageState();
}

class _AdminDashboardPageState
    extends State<AdminDashboardPage> {

  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {

    super.initState();

    pages = [

      const DashboardHome(),

      AddDrugPage(
        key: UniqueKey(),
      ),

      AdminDrugManagementPage(
        key: UniqueKey(),
      ),

      UserManagementPage(
        key: UniqueKey(),
      ),

      DrugDatabasePage(
        key: UniqueKey(),
      ),

      PediatricDosePage(
        key: UniqueKey(),
      ),
    ];
  }

  final List<Map<String, dynamic>>
      menuItems = [

    {
      'title': 'Dashboard',
      'icon': Icons.dashboard_rounded,
    },

    {
      'title': 'Add Drug',
      'icon': Icons.add_box_rounded,
    },

    {
      'title': 'Drug Management',
      'icon': Icons.medication_rounded,
    },

    {
      'title': 'User Management',
      'icon': Icons.people_alt_rounded,
    },

    {
      'title': 'Drug Database',
      'icon': Icons.storage_rounded,
    },

    {
      'title': 'Pediatric Dose',
      'icon': Icons.child_care_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff071227),

      body: Row(

        children: [

          // ======================
          // SIDEBAR
          // ======================

          Container(

            width: 300,

            color:
                const Color(0xff16243d),

            child: Column(

              children: [

                const SizedBox(
                  height: 50,
                ),

                const Icon(

                  Icons.local_hospital_rounded,

                  color:
                      Colors.cyanAccent,

                  size: 70,
                ),

                const SizedBox(
                  height: 20,
                ),

                Text(

                  'Clinical Admin',

                  style:
                      GoogleFonts.poppins(

                    color:
                        Colors.white,

                    fontSize: 32,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                Expanded(

                  child:
                      ListView.builder(

                    itemCount:
                        menuItems.length,

                    itemBuilder:
                        (
                      context,
                      index,
                    ) {

                      final item =
                          menuItems[index];

                      final selected =
                          selectedIndex ==
                              index;

                      return Padding(

                        padding:
                            const EdgeInsets.symmetric(

                          horizontal: 12,
                          vertical: 6,
                        ),

                        child:
                            AnimatedContainer(

                          duration:
                              const Duration(
                            milliseconds: 250,
                          ),

                          decoration:
                              BoxDecoration(

                            color:
                                selected

                                    ? Colors.cyanAccent
                                        .withOpacity(
                                        0.15,
                                      )

                                    : Colors.transparent,

                            borderRadius:
                                BorderRadius.circular(
                              18,
                            ),
                          ),

                          child:
                              ListTile(

                            leading:
                                Icon(

                              item['icon'],

                              color:
                                  selected

                                      ? Colors.cyanAccent

                                      : Colors.white,

                              size: 28,
                            ),

                            title:
                                Text(

                              item['title'],

                              style:
                                  GoogleFonts.poppins(

                                color:
                                    selected

                                        ? Colors.cyanAccent

                                        : Colors.white,

                                fontSize: 18,

                                fontWeight:
                                    selected

                                        ? FontWeight.bold

                                        : FontWeight.normal,
                              ),
                            ),

                            onTap:
                                () {

                              setState(() {

                                selectedIndex =
                                    index;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(
                  color:
                      Colors.white24,
                ),

                ListTile(

                  leading: const Icon(

                    Icons.logout,

                    color:
                        Colors.white,
                  ),

                  title: Text(

                    'Logout',

                    style:
                        GoogleFonts.poppins(
                      color:
                          Colors.white,
                    ),
                  ),

                  onTap:
                      () async {

                    await AuthService.logout();

                    if (!mounted) {
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
                ),

                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),

          // ======================
          // CONTENT
          // ======================

          Expanded(

            child:
                AnimatedSwitcher(

              duration:
                  const Duration(
                milliseconds: 300,
              ),

              child:
                  pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// DASHBOARD HOME
// =====================================================

class DashboardHome
    extends StatelessWidget {

  const DashboardHome({
    super.key,
  });

  Widget dashboardCard({

    required IconData icon,

    required String title,

    required String value,

    required Color color,

  }) {

    return Container(

      padding:
          const EdgeInsets.all(
        24,
      ),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          25,
        ),

        color:
            const Color(0xff16243d),

        boxShadow: [

          BoxShadow(

            color:
                color.withOpacity(
              0.25,
            ),

            blurRadius: 20,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Icon(

            icon,

            color: color,

            size: 36,
          ),

          const Spacer(),

          Text(

            value,

            style:
                GoogleFonts.poppins(

              color:
                  Colors.white,

              fontSize: 34,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(

            title,

            style:
                GoogleFonts.poppins(

              color:
                  Colors.white70,

              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      padding:
          const EdgeInsets.all(
        35,
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(

            'Dashboard Overview',

            style:
                GoogleFonts.poppins(

              color:
                  Colors.white,

              fontSize: 40,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Text(

            'Clinical Prescription System',

            style:
                GoogleFonts.poppins(

              color:
                  Colors.white54,

              fontSize: 18,
            ),
          ),

          const SizedBox(
            height: 35,
          ),

          SizedBox(

            height: 220,

            child: Row(

              children: [

                Expanded(

                  child:
                      dashboardCard(

                    icon:
                        Icons.medication_rounded,

                    title:
                        'Total Drugs',

                    value: '128',

                    color:
                        Colors.cyanAccent,
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(

                  child:
                      dashboardCard(

                    icon:
                        Icons.people_alt_rounded,

                    title:
                        'Users',

                    value: '42',

                    color:
                        Colors.orangeAccent,
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                Expanded(

                  child:
                      dashboardCard(

                    icon:
                        Icons.receipt_long_rounded,

                    title:
                        'Prescriptions',

                    value: '560',

                    color:
                        Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 35,
          ),

          Container(

            height: 400,

            padding:
                const EdgeInsets.all(
              25,
            ),

            decoration: BoxDecoration(

              color:
                  const Color(0xff16243d),

              borderRadius:
                  BorderRadius.circular(
                30,
              ),
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(

                  'Prescription Analytics',

                  style:
                      GoogleFonts.poppins(

                    color:
                        Colors.white,

                    fontSize: 24,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Expanded(

                  child:
                      LineChart(

                    LineChartData(

                      borderData:
                          FlBorderData(
                        show: false,
                      ),

                      gridData:
                          FlGridData(
                        show: true,
                      ),

                      lineBarsData: [

                        LineChartBarData(

                          isCurved: true,

                          color:
                              Colors.cyanAccent,

                          barWidth: 5,

                          spots: const [

                            FlSpot(0, 1),
                            FlSpot(1, 3),
                            FlSpot(2, 2),
                            FlSpot(3, 5),
                            FlSpot(4, 4),
                            FlSpot(5, 7),
                            FlSpot(6, 6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}