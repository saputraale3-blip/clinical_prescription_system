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

  final mgKgMinController =
      TextEditingController();

  final mgKgMaxController =
      TextEditingController();

  final syrupMgController =
      TextEditingController();

  final syrupMlController =
      TextEditingController();

  final categories = [

    'Analgesic',

    'Antibiotic',

    'Antifungal',

    'Antiviral',

    'Antihistamine',
  ];

  final dosageForms = [

    'tablet',

    'syrup',

    'capsule',

    'drops',

    'suspension',
  ];

  final databaseTypes = [

    'drug database',

    'pediatric',
  ];

  String selectedCategory =
      'Analgesic';

  String selectedDosageForm =
      'tablet';

  String selectedDatabaseType =
      'drug database';

  bool isLoading = false;

  bool get isPediatric {

    return selectedDatabaseType ==
        'pediatric';
  }

  bool get isSyrup {

    return selectedDosageForm ==
            'syrup' ||

        selectedDosageForm ==
            'drops' ||

        selectedDosageForm ==
            'suspension';
  }

  InputDecoration inputStyle(
      String label) {

    return InputDecoration(

      labelText: label,

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          14,
        ),
      ),
    );
  }

  Future<void> saveDrug()
      async {

    try {

      setState(() {

        isLoading = true;
      });

      await SupabaseService
          .addDrug(

        name:
            nameController.text
                .trim(),

        genericName:
            genericNameController
                .text
                .trim(),

        category:
            selectedCategory,

        dosageForm:
            selectedDosageForm,

        dose:
            doseController.text
                .trim(),

        frequency:
            frequencyController
                .text
                .trim(),

        prescription:
            prescriptionController
                .text
                .trim(),

        note:
            noteController.text
                .trim(),

        drugType:
            selectedDatabaseType,

        mgPerKgMin:
            double.tryParse(
                  mgKgMinController
                      .text,
                ) ??
                0,

        mgPerKgMax:
            double.tryParse(
                  mgKgMaxController
                      .text,
                ) ??
                0,

        syrupMg:
            double.tryParse(
                  syrupMgController
                      .text,
                ) ??
                0,

        syrupMl:
            double.tryParse(
                  syrupMlController
                      .text,
                ) ??
                0,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
              context)
          .showSnackBar(

        const SnackBar(

          content:
              Text(
            'Drug added successfully',
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(
              context)
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

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
            const Text(
          'Add Drug',
        ),
      ),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(

          children: [

            TextField(

              controller:
                  nameController,

              decoration:
                  inputStyle(
                'Drug Name',
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
                  genericNameController,

              decoration:
                  inputStyle(
                'Generic Name',
              ),
            ),

            const SizedBox(
                height: 20),

            DropdownButtonFormField<
                String>(

              value:
                  selectedCategory,

              decoration:
                  inputStyle(
                'Category',
              ),

              items:
                  categories.map(
                      (e) {

                return DropdownMenuItem(

                  value: e,

                  child:
                      Text(e),
                );
              }).toList(),

              onChanged:
                  (value) {

                setState(() {

                  selectedCategory =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            DropdownButtonFormField<
                String>(

              value:
                  selectedDosageForm,

              decoration:
                  inputStyle(
                'Dosage Form',
              ),

              items:
                  dosageForms.map(
                      (e) {

                return DropdownMenuItem(

                  value: e,

                  child:
                      Text(e),
                );
              }).toList(),

              onChanged:
                  (value) {

                setState(() {

                  selectedDosageForm =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            DropdownButtonFormField<
                String>(

              value:
                  selectedDatabaseType,

              decoration:
                  inputStyle(
                'Database Type',
              ),

              items:
                  databaseTypes.map(
                      (e) {

                return DropdownMenuItem(

                  value: e,

                  child:
                      Text(e),
                );
              }).toList(),

              onChanged:
                  (value) {

                setState(() {

                  selectedDatabaseType =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
                  doseController,

              decoration:
                  inputStyle(
                'Dose',
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
                  frequencyController,

              decoration:
                  inputStyle(
                'Frequency',
              ),
            ),

            const SizedBox(
                height: 20),

            if (isPediatric)

              Column(

                children: [

                  TextField(

                    controller:
                        mgKgMinController,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        inputStyle(
                      'mg/kg Min',
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  TextField(

                    controller:
                        mgKgMaxController,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        inputStyle(
                      'mg/kg Max',
                    ),
                  ),

                  const SizedBox(
                      height: 20),
                ],
              ),

            if (isPediatric &&
                isSyrup)

              Column(

                children: [

                  TextField(

                    controller:
                        syrupMgController,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        inputStyle(
                      'Syrup mg',
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  TextField(

                    controller:
                        syrupMlController,

                    keyboardType:
                        TextInputType
                            .number,

                    decoration:
                        inputStyle(
                      'Syrup ml',
                    ),
                  ),

                  const SizedBox(
                      height: 20),
                ],
              ),

            TextField(

              controller:
                  prescriptionController,

              maxLines: 8,

              decoration:
                  inputStyle(
                'Prescription',
              ),
            ),

            const SizedBox(
                height: 20),

            TextField(

              controller:
                  noteController,

              maxLines: 6,

              decoration:
                  inputStyle(
                'Clinical Note',
              ),
            ),

            const SizedBox(
                height: 30),

            SizedBox(

              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : saveDrug,

                child:
                    isLoading

                        ? const CircularProgressIndicator()

                        : const Text(
                            'SAVE DRUG',
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}