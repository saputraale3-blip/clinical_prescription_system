import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class EditDrugPage
    extends StatefulWidget {

  final Map<String, dynamic> drug;

  const EditDrugPage({

    super.key,

    required this.drug,
  });

  @override
  State<EditDrugPage> createState() =>
      _EditDrugPageState();
}

class _EditDrugPageState
    extends State<EditDrugPage> {

  late TextEditingController
      nameController;

  late TextEditingController
      genericNameController;

  late TextEditingController
      doseController;

  late TextEditingController
      frequencyController;

  late TextEditingController
      prescriptionController;

  late TextEditingController
      noteController;

  late TextEditingController
      mgPerKgMinController;

  late TextEditingController
      mgPerKgMaxController;

  late TextEditingController
      syrupMgController;

  late TextEditingController
      syrupMlController;

  @override
  void initState() {

    super.initState();

    final drug = widget.drug;

    nameController =
        TextEditingController(
      text: drug['name'],
    );

    genericNameController =
        TextEditingController(
      text: drug['generic_name'],
    );

    doseController =
        TextEditingController(
      text: drug['dose'],
    );

    frequencyController =
        TextEditingController(
      text: drug['frequency'],
    );

    prescriptionController =
        TextEditingController(
      text: drug['prescription'],
    );

    noteController =
        TextEditingController(
      text: drug['note'],
    );

    mgPerKgMinController =
        TextEditingController(
      text:
          '${drug['mg_per_kg_min'] ?? 0}',
    );

    mgPerKgMaxController =
        TextEditingController(
      text:
          '${drug['mg_per_kg_max'] ?? 0}',
    );

    syrupMgController =
        TextEditingController(
      text:
          '${drug['syrup_mg'] ?? 0}',
    );

    syrupMlController =
        TextEditingController(
      text:
          '${drug['syrup_ml'] ?? 0}',
    );
  }

  Future<void> updateDrug() async {

    try {

      await SupabaseService
          .updateDrug(

        id: widget.drug['id'],

        name:
            nameController.text,

        genericName:
            genericNameController.text,

        category:
            widget.drug['category'],

        dosageForm:
            widget.drug['dosage_form'],

        dose:
            doseController.text,

        frequency:
            frequencyController.text,

        prescription:
            prescriptionController.text,

        note:
            noteController.text,

        drugType:
            widget.drug['drug_type'],

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
            const Text('Edit Drug'),

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
                  updateDrug,

              child:
                  const Text(
                'UPDATE DRUG',
              ),
            ),
          ],
        ),
      ),
    );
  }
}