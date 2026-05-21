import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class AddDrugPage extends StatefulWidget {

  const AddDrugPage({super.key});

  @override
  State<AddDrugPage> createState() =>
      _AddDrugPageState();
}

class _AddDrugPageState
    extends State<AddDrugPage> {

  final nameController =
      TextEditingController();

  final genericNameController =
      TextEditingController();

  final doseController =
      TextEditingController();

  final frequencyController =
      TextEditingController();

  final prescriptionController =
      TextEditingController();

  final noteController =
      TextEditingController();

  final mgPerKgMinController =
      TextEditingController();

  final mgPerKgMaxController =
      TextEditingController();

  final syrupMgController =
      TextEditingController();

  final syrupMlController =
      TextEditingController();

  String selectedCategory =
      'Analgesic';

  String selectedDosageForm =
      'Tablet';

  String selectedDatabase =
      'adult';

  bool isLoading = false;

  Future<void> addDrug() async {

    setState(() {
      isLoading = true;
    });

    try {

      await SupabaseService.addDrug(

        name:
            nameController.text,

        genericName:
            genericNameController.text,

        category:
            selectedCategory,

        dosageForm:
            selectedDosageForm,

        dose:
            doseController.text,

        frequency:
            frequencyController.text,

        prescription:
            prescriptionController.text,

        note:
            noteController.text,

        drugType:
            selectedDatabase,

        mgPerKgMin:
            double.tryParse(
              mgPerKgMinController.text,
            ) ?? 0,

        mgPerKgMax:
            double.tryParse(
              mgPerKgMaxController.text,
            ) ?? 0,

        syrupMg:
            double.tryParse(
              syrupMgController.text,
            ) ?? 0,

        syrupMl:
            double.tryParse(
              syrupMlController.text,
            ) ?? 0,
      );

      if (!mounted) return;

      Navigator.pop(context);
    }

    catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildInput({

    required TextEditingController
        controller,

    required String label,

  }) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 15,
      ),

      child: TextField(

        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          labelText: label,

          labelStyle:
              const TextStyle(
            color: Colors.white70,
          ),

          filled: true,

          fillColor:
              const Color(0xFF1E1E1E),

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        title:
            const Text('Add Drug'),

        backgroundColor:
            Colors.black,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            buildInput(
              controller:
                  nameController,
              label: 'Drug Name',
            ),

            buildInput(
              controller:
                  genericNameController,
              label: 'Generic Name',
            ),

            buildInput(
              controller:
                  doseController,
              label: 'Dose',
            ),

            buildInput(
              controller:
                  frequencyController,
              label: 'Frequency',
            ),

            buildInput(
              controller:
                  prescriptionController,
              label: 'Prescription',
            ),

            buildInput(
              controller:
                  noteController,
              label: 'Note',
            ),

            buildInput(
              controller:
                  mgPerKgMinController,
              label: 'mg/kg Min',
            ),

            buildInput(
              controller:
                  mgPerKgMaxController,
              label: 'mg/kg Max',
            ),

            buildInput(
              controller:
                  syrupMgController,
              label: 'Syrup mg',
            ),

            buildInput(
              controller:
                  syrupMlController,
              label: 'Syrup ml',
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed:
                  isLoading
                      ? null
                      : addDrug,

              child:
                  const Text(
                'ADD DRUG',
              ),
            ),
          ],
        ),
      ),
    );
  }
}