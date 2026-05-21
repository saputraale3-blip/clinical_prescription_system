import 'package:flutter/material.dart';

import 'pages/drug_database_page.dart';
import 'pages/pediatric_dose_page.dart';
import 'pages/prescription_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Clinical Prescription System',

      theme: ThemeData.dark().copyWith(

        scaffoldBackgroundColor: const Color(0xFF121212),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),

        cardColor: const Color(0xFF1E1E1E),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),

      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Clinical Prescription System',
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: GridView.count(

          crossAxisCount: 2,

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,

          children: [

            DashboardCard(

              title: 'Drug Database',

              icon: Icons.medication,

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DrugDatabasePage(),
                  ),
                );

              },
            ),

            DashboardCard(

              title: 'Pediatric Dose',

              icon: Icons.child_care,

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PediatricDosePage(),
                  ),
                );

              },
            ),

            DashboardCard(

              title: 'Prescription',

              icon: Icons.receipt_long,

              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrescriptionPage(),
                  ),
                );

              },
            ),

            DashboardCard(

              title: 'Drug Interaction',

              icon: Icons.warning_amber_rounded,

              onTap: () {

                ScaffoldMessenger.of(context).showSnackBar(

                  const SnackBar(
                    content: Text(
                      'Drug Interaction Checker Coming Soon',
                    ),
                  ),
                );

              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {

  final String title;

  final IconData icon;

  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      borderRadius: BorderRadius.circular(24),

      onTap: onTap,

      child: Card(

        elevation: 6,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              Icon(
                icon,
                size: 70,
                color: Colors.cyanAccent,
              ),

              const SizedBox(height: 24),

              Text(

                title,

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}