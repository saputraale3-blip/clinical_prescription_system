import 'package:flutter/material.dart';

import 'add_drug_page.dart';
import 'drug_database_page.dart';
import 'pediatric_dose_page.dart';
import 'login_page.dart';
import 'admin_drug_management_page.dart';
import 'user_management_page.dart';

import '../services/auth_service.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  Widget buildMenu({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget page,
    Color color = Colors.cyanAccent,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 55,
              color: color,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
        ),
        backgroundColor: Colors.black,

        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,

          children: [

            // =========================
            // ADD DRUG
            // =========================

            buildMenu(
              context: context,
              title: 'Add Drug',
              icon: Icons.add_box,
              color: Colors.greenAccent,
              page: const AddDrugPage(),
            ),

            // =========================
            // DRUG DATABASE
            // =========================

            buildMenu(
              context: context,
              title: 'Drug Database',
              icon: Icons.local_pharmacy,
              color: Colors.cyanAccent,
              page: const DrugDatabasePage(),
            ),

            // =========================
            // PEDIATRIC DOSE
            // =========================

            buildMenu(
              context: context,
              title: 'Pediatric Dose',
              icon: Icons.child_care,
              color: Colors.orangeAccent,
              page: const PediatricDosePage(),
            ),

            // =========================
            // DRUG MANAGEMENT
            // =========================

            buildMenu(
              context: context,
              title: 'Drug Management',
              icon: Icons.edit_note,
              color: Colors.purpleAccent,
              page: const AdminDrugManagementPage(),
            ),

            // =========================
            // USER MANAGEMENT
            // =========================

            buildMenu(
              context: context,
              title: 'User Management',
              icon: Icons.manage_accounts,
              color: Colors.redAccent,
              page: const UserManagementPage(),
            ),
          ],
        ),
      ),
    );
  }
}