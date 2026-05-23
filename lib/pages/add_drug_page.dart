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

  // =====================================================
  // CONTROLLERS
  // =====================================================

  final nameController =
      TextEditingController();

  final genericNameController =
      TextEditingController();

  final doseController =
      TextEditingController();

  final noteController =
      TextEditingController();

  final qtyController =
      TextEditingController(
    text: '10',
  );

  final mgKgMinController =
      TextEditingController();

  final mgKgMaxController =
      TextEditingController();

  final syrupMgController =
      TextEditingController();

  final syrupMlController =
      TextEditingController();

  // =====================================================
  // DROPDOWN DATA
  // =====================================================

  final categories = [

    'Analgesic',

    'Antibiotic',

    'Antifungal',

    'Antiviral',

    'Antihistamine',

    'Antacid',

    'Vitamin',

    'Antihypertensive',

    'Respiratory',
  ];

  final dosageForms = [

    'tablet',

    'capsule',

    'syrup',

    'drops',

    'suspension',

    'cream',

    'ointment',
  ];

  final databaseTypes = [

    'drug database',

    'pediatric',
  ];

  final frequencyList = [

    '1 dd',

    '2 dd',

    '3 dd',

    '4 dd',
  ];

  final signaUnitList = [

    'tab',

    'caps',

    'cth',

    'gtt',

    'ung',
  ];

  final signaNoteList = [

    'p.c',

    'a.c',

    'h.s',

    'prn',

    '-',
  ];

  // =====================================================
  // SELECTED VALUE
  // =====================================================

  String selectedCategory =
      'Analgesic';

  String selectedDosageForm =
      'tablet';

  String selectedDatabaseType =
      'drug database';

  String selectedFrequency =
      '3 dd';

  String selectedSignaUnit =
      'tab';

  String selectedSignaNote =
      'p.c';

  bool isLoading = false;

  // =====================================================
  // GETTER
  // =====================================================

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

  // =====================================================
  // INPUT STYLE
  // =====================================================

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

  // =====================================================
  // BUILD PRESCRIPTION
  // =====================================================

  String buildPrescription() {

    String formText = '';

    if (selectedDosageForm ==
        'tablet') {

      formText = 'Tab';

    } else if (selectedDosageForm ==
        'capsule') {

      formText = 'Caps';

    } else if (selectedDosageForm ==
        'syrup') {

      formText = 'Fl';

    } else if (selectedDosageForm ==
        'cream') {

      formText = 'Ung';

    } else {

      formText =
          selectedDosageForm;
    }

    return '''

R/

${nameController.text} ${doseController.text}

$formText No. ${qtyController.text}

S $selectedFrequency $selectedSignaUnit I $selectedSignaNote

''';
  }

  // =====================================================
  // SAVE DRUG
  // =====================================================

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

        // =================================
        // NEW SYSTEM
        // =================================

        frequency:
            selectedFrequency,

        frequencySigna:
            selectedFrequency,

        signaUnit:
            selectedSignaUnit,

        signaNote:
            selectedSignaNote,

        qtyDefault:
            int.tryParse(
                  qtyController
                      .text,
                ) ??
                10,

        prescription:
            buildPrescription(),

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

      clearForm();

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

  // =====================================================
  // CLEAR FORM
  // =====================================================

  void clearForm() {

    nameController.clear();

    genericNameController
        .clear();

    doseController.clear();

    noteController.clear();

    mgKgMinController.clear();

    mgKgMaxController.clear();

    syrupMgController.clear();

    syrupMlController.clear();

    qtyController.text = '10';
  }

  // =====================================================
  // UI
  // =====================================================

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

            // =====================================
            // NAME
            // =====================================

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

            // =====================================
            // CATEGORY
            // =====================================

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

            // =====================================
            // DOSAGE FORM
            // =====================================

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

            // =====================================
            // DATABASE TYPE
            // =====================================

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

            // =====================================
            // DOSE
            // =====================================

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

            // =====================================
            // FREQUENCY
            // =====================================

            DropdownButtonFormField<
                String>(

              value:
                  selectedFrequency,

              decoration:
                  inputStyle(
                'Frequency Signa',
              ),

              items:
                  frequencyList.map(
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

                  selectedFrequency =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            // =====================================
            // SIGNA UNIT
            // =====================================

            DropdownButtonFormField<
                String>(

              value:
                  selectedSignaUnit,

              decoration:
                  inputStyle(
                'Signa Unit',
              ),

              items:
                  signaUnitList.map(
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

                  selectedSignaUnit =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            // =====================================
            // SIGNA NOTE
            // =====================================

            DropdownButtonFormField<
                String>(

              value:
                  selectedSignaNote,

              decoration:
                  inputStyle(
                'Signa Note',
              ),

              items:
                  signaNoteList.map(
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

                  selectedSignaNote =
                      value!;
                });
              },
            ),

            const SizedBox(
                height: 20),

            // =====================================
            // QTY
            // =====================================

            TextField(

              controller:
                  qtyController,

              keyboardType:
                  TextInputType
                      .number,

              decoration:
                  inputStyle(
                'Qty Default',
              ),
            ),

            const SizedBox(
                height: 20),

            // =====================================
            // PEDIATRIC
            // =====================================

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

            // =====================================
            // SYRUP
            // =====================================

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

            // =====================================
            // AUTO PRESCRIPTION PREVIEW
            // =====================================

            Container(

              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration:
                  BoxDecoration(

                borderRadius:
                    BorderRadius.circular(
                  16,
                ),

                color: Colors
                    .grey
                    .withOpacity(
                  0.1,
                ),
              ),

              child: Text(

                buildPrescription(),

                style:
                    const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            // =====================================
            // NOTE
            // =====================================

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

            // =====================================
            // SAVE BUTTON
            // =====================================

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