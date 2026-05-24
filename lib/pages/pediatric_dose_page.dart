import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class PediatricDosePage extends StatefulWidget {
  const PediatricDosePage({super.key});

  @override
  State<PediatricDosePage> createState() =>
      _PediatricDosePageState();
}

class _PediatricDosePageState
    extends State<PediatricDosePage> {

  final TextEditingController weightController =
      TextEditingController();

  final TextEditingController durationController =
      TextEditingController(text: '5');

  List<Map<String, dynamic>> drugs = [];
  List<Map<String, dynamic>> filteredDrugs = [];

  List<String> categories = [];

  final List<String> dosageForms = [
    'tablet',
    'capsule',
    'syrup',
    'drops',
    'suspension',
  ];

  String? selectedCategory;
  String? selectedDosageForm = 'syrup';

  Map<String, dynamic>? selectedDrug;

  String result = '';
  String generatedPrescription = '';
  String clinicalNote = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDrugs();
  }

  // =====================================================
  // LOAD DRUGS
  // =====================================================

  Future<void> loadDrugs() async {

    try {

      final data =
          await SupabaseService
              .getPediatricDrugs();

      drugs =
          List<Map<String, dynamic>>
              .from(data);

      categories = drugs
          .map(
            (e) => (e['category'] ?? '')
                .toString(),
          )
          .toSet()
          .toList();

      categories.sort();

      if (categories.isNotEmpty) {
        selectedCategory = categories.first;
      }

      filterDrugs();

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================================
  // FILTER
  // =====================================================

  void filterDrugs() {

    filteredDrugs =
        drugs.where((drug) {

      final category =
          (drug['category'] ?? '')
              .toString()
              .toLowerCase();

      final dosageForm =
          (drug['dosage_form'] ?? '')
              .toString()
              .toLowerCase();

      return category ==
              selectedCategory!
                  .toLowerCase() &&
          dosageForm ==
              selectedDosageForm!
                  .toLowerCase();

    }).toList();

    if (filteredDrugs.isNotEmpty) {
      selectedDrug =
          filteredDrugs.first;
    }

    setState(() {});
  }

  // =====================================================
  // SEARCH DIALOG
  // =====================================================

  Future<void> showDrugSearch() async {

    final searchController =
        TextEditingController();

    List<Map<String, dynamic>>
        tempList =
        List.from(filteredDrugs);

    await showDialog(

      context: context,

      barrierColor: Colors.black54,

      builder: (context) {

        return StatefulBuilder(

          builder:
              (context,
                  setStateDialog) {

            return Dialog(

              backgroundColor:
                  Colors.transparent,

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(
                  30,
                ),

                child: BackdropFilter(

                  filter:
                      ImageFilter.blur(
                    sigmaX: 18,
                    sigmaY: 18,
                  ),

                  child: Container(

                    padding:
                        const EdgeInsets.all(
                      22,
                    ),

                    decoration:
                        BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),

                      color: Colors
                          .white
                          .withOpacity(
                        0.06,
                      ),
                    ),

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        TextField(

                          controller:
                              searchController,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),

                          decoration:
                              cyberInput(
                            'Search Drug',
                          ),

                          onChanged:
                              (value) {

                            setStateDialog(
                              () {

                                tempList =
                                    filteredDrugs
                                        .where(
                                  (drug) {

                                    final text =
                                        '${drug['name']} ${drug['concentration']}'
                                            .toLowerCase();

                                    return text
                                        .contains(
                                      value
                                          .toLowerCase(),
                                    );
                                  },
                                ).toList();
                              },
                            );
                          },
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        SizedBox(

                          height: 420,

                          child:
                              ListView.builder(

                            itemCount:
                                tempList.length,

                            itemBuilder:
                                (
                              context,
                              index,
                            ) {

                              final drug =
                                  tempList[
                                      index];

                              return ListTile(

                                title: Text(

                                  '${drug['name']} (${drug['concentration']})',

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                onTap:
                                    () {

                                  setState(
                                    () {

                                      selectedDrug =
                                          drug;
                                    },
                                  );

                                  Navigator.pop(
                                    context,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =====================================================
  // ROMAN
  // =====================================================

  String toRoman(int number) {

    final romanNumerals = {

      1000: 'M',
      900: 'CM',
      500: 'D',
      400: 'CD',
      100: 'C',
      90: 'XC',
      50: 'L',
      40: 'XL',
      10: 'X',
      9: 'IX',
      5: 'V',
      4: 'IV',
      1: 'I',
    };

    String result = '';

    romanNumerals.forEach((value, symbol) {

      while (number >= value) {

        result += symbol;

        number -= value;
      }
    });

    return result;
  }

  // =====================================================
  // CALCULATE DOSE
  // =====================================================

  void calculateDose() {

    if (selectedDrug == null) {

      setState(() {
        result = 'Drug not found';
      });

      return;
    }

    final weight =
        double.tryParse(weightController.text);

    final duration =
        double.tryParse(durationController.text);

    if (weight == null || weight <= 0) {

      setState(() {
        result = 'Invalid weight';
      });

      return;
    }

    if (duration == null || duration <= 0) {

      setState(() {
        result = 'Invalid duration';
      });

      return;
    }

    // =====================================================
    // DATABASE VALUES
    // =====================================================

    final mgPerKgMin =
        double.tryParse(
              (selectedDrug!['mg_per_kg_min'] ?? '0')
                  .toString(),
            ) ??
            0;

    final mgPerKgMax =
        double.tryParse(
              (selectedDrug!['mg_per_kg_max'] ?? '0')
                  .toString(),
            ) ??
            0;

    final concentration =
        (selectedDrug!['concentration'] ?? '')
            .toString();

    final dosageForm =
        (selectedDrug!['dosage_form'] ?? '')
            .toString()
            .toLowerCase();

    final drugName =
        selectedDrug!['name'].toString();

    clinicalNote =
        selectedDrug!['indication'] ?? '-';

    // =====================================================
    // CALCULATE MG
    // =====================================================

    final doseMgMin =
        weight * mgPerKgMin;

    final doseMgMax =
        weight * mgPerKgMax;

    String calculatedDose = '';
    String smartSigna = '';
    String qtyText = '';

    // =====================================================
    // SYRUP
    // =====================================================

    if (dosageForm == 'syrup' ||
        dosageForm == 'drops' ||
        dosageForm == 'suspension') {

      final split =
          concentration.split('/');

      final mgPart =
          split.first
              .replaceAll('mg', '')
              .trim();

      final mlPart =
          split.last
              .replaceAll('ml', '')
              .replaceAll('mL', '')
              .trim();

      final concMg =
          double.tryParse(mgPart) ?? 120;

      final concMl =
          double.tryParse(mlPart) ?? 5;

      // =====================================================
      // ML CALCULATION
      // =====================================================

      double doseMlMin =
          (doseMgMin / concMg) * concMl;

      double doseMlMax =
          (doseMgMax / concMg) * concMl;

      doseMlMin =
          double.parse(
        doseMlMin.toStringAsFixed(1),
      );

      doseMlMax =
          double.parse(
        doseMlMax.toStringAsFixed(1),
      );

      final totalMl =
          doseMlMax * 3 * duration;

      final bottleCount =
          (totalMl / 60).ceil();

      calculatedDose =

          '${doseMgMin.toStringAsFixed(0)} - '

          '${doseMgMax.toStringAsFixed(0)} mg/dose\n\n'

          '${doseMlMin.toStringAsFixed(1)} - '

          '${doseMlMax.toStringAsFixed(1)} mL per dose';

      smartSigna =

          'S 3 dd '

          '${doseMlMin.toStringAsFixed(1)} - '

          '${doseMlMax.toStringAsFixed(1)} mL p.c';

      qtyText =
          'Flac. No. ${toRoman(bottleCount)}';
    }

    // =====================================================
    // TABLET
    // =====================================================

    else {

      final strength =
          double.tryParse(
                concentration
                    .replaceAll('mg', '')
                    .trim(),
              ) ??
              500;

      double tabDoseMin =
          doseMgMin / strength;

      double tabDoseMax =
          doseMgMax / strength;

      tabDoseMin =
          double.parse(
        tabDoseMin.toStringAsFixed(2),
      );

      tabDoseMax =
          double.parse(
        tabDoseMax.toStringAsFixed(2),
      );

      final totalTab =
          (tabDoseMax * 3 * duration)
              .ceil();

      calculatedDose =

          '${doseMgMin.toStringAsFixed(0)} - '

          '${doseMgMax.toStringAsFixed(0)} mg/dose\n\n'

          '${tabDoseMin.toStringAsFixed(2)} - '

          '${tabDoseMax.toStringAsFixed(2)} tablet';

      smartSigna =

          'S 3 dd '

          '${tabDoseMin.toStringAsFixed(2)} - '

          '${tabDoseMax.toStringAsFixed(2)} tab p.c';

      qtyText =
          'No. ${toRoman(totalTab)}';
    }

    setState(() {

      result = calculatedDose;

      generatedPrescription = '''

R/

$drugName ($concentration)

$qtyText

$smartSigna

''';
    });
  }

  // =====================================================
  // INPUT STYLE
  // =====================================================

  InputDecoration cyberInput(String label) {

    return InputDecoration(

      labelText: label,

      labelStyle:
          TextStyle(
        color:
            Colors.white.withOpacity(0.7),
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.05),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
    );
  }

  // =====================================================
  // UI
  // =====================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.transparent,

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                children: [

                  DropdownButtonFormField<String>(

                    value: selectedCategory,

                    decoration:
                        cyberInput('Category'),

                    items:
                        categories.map((e) {

                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),

                    onChanged: (value) {

                      selectedCategory = value;

                      filterDrugs();
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(

                    value: selectedDosageForm,

                    decoration:
                        cyberInput(
                      'Dosage Form',
                    ),

                    items:
                        dosageForms.map((e) {

                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),

                    onChanged: (value) {

                      selectedDosageForm = value;

                      filterDrugs();
                    },
                  ),

                  const SizedBox(height: 20),

                  InkWell(

                    onTap: showDrugSearch,

                    child: Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(18),

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(18),

                        color:
                            Colors.white.withOpacity(0.05),
                      ),

                      child: Text(

                        selectedDrug == null

                            ? 'Select Drug'

                            : '${selectedDrug!['name']} (${selectedDrug!['concentration']})',

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller:
                        weightController,

                    keyboardType:
                        TextInputType.number,

                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        cyberInput(
                      'Weight (kg)',
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextField(

                    controller:
                        durationController,

                    keyboardType:
                        TextInputType.number,

                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        cyberInput(
                      'Duration (days)',
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(

                    width: double.infinity,

                    height: 58,

                    child: ElevatedButton(

                      onPressed:
                          calculateDose,

                      child: const Text(
                        'CALCULATE',
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (result.isNotEmpty)

                    Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(24),

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(24),

                        color:
                            Colors.white.withOpacity(0.05),
                      ),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(

                            'Calculated Dose',

                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(

                            result,

                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(

                            'Generated Prescription',

                            style: TextStyle(
                              color:
                                  Colors.orangeAccent,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(

                            generatedPrescription,

                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              height: 1.8,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(

                            'Clinical Note',

                            style: TextStyle(
                              color:
                                  Colors.orangeAccent,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(

                            clinicalNote,

                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}