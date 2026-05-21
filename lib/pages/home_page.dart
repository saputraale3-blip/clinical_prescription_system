import 'package:flutter/material.dart';

import '../services/auth_service.dart';

import 'login_page.dart';
import 'pediatric_dose_page.dart';
import 'drug_database_page.dart';
import 'add_drug_page.dart';
import 'admin_dashboard_page.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {

  bool isAdmin = false;

  @override
  void initState() {

    super.initState();

    loadRole();
  }

  Future<void> loadRole() async {

    try {

      final admin =
          await AuthService.isAdmin();

      if (mounted) {

        setState(() {

          isAdmin = admin;
        });
      }
    }

    catch (e) {

      debugPrint(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

if (isAdmin) {

  return const AdminDashboardPage();
}

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        title: const Text(
          'Clinical Prescription System',
        ),

        backgroundColor:
            Colors.black,

        actions: [

          if (isAdmin)

            const Padding(

              padding: EdgeInsets.only(
                right: 10,
              ),

              child: Center(

                child: Text(

                  'ADMIN',

                  style: TextStyle(

                    color:
                        Colors.cyanAccent,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          IconButton(

            onPressed: () async {

              await AuthService.logout();

              if (!mounted) return;

              Navigator.pushAndRemoveUntil(

                context,

                MaterialPageRoute(

                  builder: (context) =>
                      const LoginPage(),
                ),

                (route) => false,
              );
            },

            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),

      floatingActionButton:

          isAdmin

              ? FloatingActionButton(

                  backgroundColor:
                      Colors.cyanAccent,

                  onPressed: () async {

                    await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder: (context) =>
                            const AddDrugPage(),
                      ),
                    );

                    if (mounted) {

                      setState(() {});
                    }
                  },

                  child: const Icon(

                    Icons.add,

                    color: Colors.black,
                  ),
                )

              : null,

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 20,

          mainAxisSpacing: 20,

          children: [

            buildMenuCard(

              context,

              title:
                  'Pediatric Dose',

              icon:
                  Icons.medication,

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                        const PediatricDosePage(),
                  ),
                );
              },
            ),

            buildMenuCard(

              context,

              title:
                  'Drug Database',

              icon:
                  Icons.local_pharmacy,

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (context) =>
                        const DrugDatabasePage(),
                  ),
                );
              },
            ),

            buildMenuCard(

              context,

              title:
                  'Prescription',

              icon:
                  Icons.description,

              onTap: () {},
            ),

            buildMenuCard(

              context,

              title:
                  'Settings',

              icon:
                  Icons.settings,

              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuCard(

    BuildContext context, {

    required String title,

    required IconData icon,

    required VoidCallback onTap,

  }) {

    return InkWell(

      onTap: onTap,

      borderRadius:
          BorderRadius.circular(20),

      child: Container(

        decoration: BoxDecoration(

          color:
              const Color(0xFF1E1E1E),

          borderRadius:
              BorderRadius.circular(20),

          boxShadow: const [

            BoxShadow(

              color: Colors.black54,

              blurRadius: 8,

              offset: Offset(0, 4),
            ),
          ],
        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(

              icon,

              size: 55,

              color:
                  Colors.cyanAccent,
            ),

            const SizedBox(height: 20),

            Text(

              title,

              textAlign:
                  TextAlign.center,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 18,

                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}