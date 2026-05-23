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
  String? selectedDosageForm = 'tablet';

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
          await SupabaseService.getPediatricDrugs();

      drugs =
          List<Map<String, dynamic>>.from(data);

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

    filteredDrugs = drugs.where((drug) {

      final category =
          (drug['category'] ?? '')
              .toString()
              .toLowerCase()
              .trim();

      final dosageForm =
          (drug['dosage_form'] ?? '')
              .toString()
              .toLowerCase()
              .trim();

      final categoryMatch =
          category ==
          (selectedCategory ?? '')
              .toLowerCase()
              .trim();

      final dosageMatch =
          dosageForm ==
          (selectedDosageForm ?? '')
              .toLowerCase()
              .trim();

      return categoryMatch &&
          dosageMatch;

    }).toList();

    if (filteredDrugs.isNotEmpty) {
      selectedDrug = filteredDrugs.first;
    } else {
      selectedDrug = null;
    }

    setState(() {});
  }

  // =====================================================
  // SEARCH DIALOG
  // =====================================================

  Future<void> showDrugSearch() async {

    final searchController =
        TextEditingController();

    List<Map<String, dynamic>> tempList =
        List.from(filteredDrugs);

    await showDialog(

      context: context,

      barrierColor: Colors.black54,

      builder: (context) {

        return StatefulBuilder(

          builder:
              (context, setStateDialog) {

            return Dialog(

              backgroundColor:
                  Colors.transparent,

              child: ClipRRect(

                borderRadius:
                    BorderRadius.circular(30),

                child: BackdropFilter(

                  filter: ImageFilter.blur(
                    sigmaX: 18,
                    sigmaY: 18,
                  ),

                  child: Container(

                    padding:
                        const EdgeInsets.all(22),

                    decoration: BoxDecoration(

                      borderRadius:
                          BorderRadius.circular(30),

                      color: Colors.white
                          .withOpacity(0.06),

                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.08),
                      ),
                    ),

                    child: Column(

                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Row(

                          children: const [

                            Icon(
                              Icons.search_rounded,
                              color:
                                  Colors.cyanAccent,
                            ),

                            SizedBox(width: 10),

                            Text(
                              'Search Drug',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        TextField(

                          controller:
                              searchController,

                          style:
                              const TextStyle(
                            color: Colors.white,
                          ),

                          decoration:
                              cyberInput(
                            'Search medicine...',
                          ),

                          onChanged: (value) {

                            setStateDialog(() {

                              tempList =
                                  filteredDrugs.where(
                                (drug) {

                                  final text =
                                      '${drug['name'] ?? ''} '
                                      '${drug['concentration'] ?? ''}'
                                          .toLowerCase();

                                  return text.contains(
                                    value.toLowerCase(),
                                  );
                                },
                              ).toList();
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        SizedBox(

                          height: 420,

                          child: ListView.builder(

                            itemCount:
                                tempList.length,

                            itemBuilder:
                                (context, index) {

                              final drug =
                                  tempList[index];

                              return Container(

                                margin:
                                    const EdgeInsets.only(
                                  bottom: 12,
                                ),

                                decoration:
                                    BoxDecoration(

                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),

                                  color: Colors.white
                                      .withOpacity(0.04),
                                ),

                                child: ListTile(

                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 10,
                                  ),

                                  leading: Container(

                                    padding:
                                        const EdgeInsets.all(
                                      10,
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

                                    child: const Icon(
                                      Icons.medication_rounded,
                                      color: Colors.white,
                                    ),
                                  ),

                                  title: Text(

                                    '${drug['name']} (${drug['concentration'] ?? '-'})',

                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  onTap: () {

                                    setState(() {
                                      selectedDrug = drug;
                                    });

                                    Navigator.pop(context);
                                  },
                                ),
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
  // ROMAN NUMBER
  // =====================================================

  String toRoman(int number) {

    if (number <= 0) return '';

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

    romanNumerals.forEach((value, numeral) {

      while (number >= value) {

        result += numeral;

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

    final mgPerKg =
        double.tryParse(
              (selectedDrug!['mg_per_kg'] ?? '0')
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

    final note =
        selectedDrug!['max_daily_dose'] ?? '-';

    final doseMg =
        weight * mgPerKg;

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
          double.tryParse(mgPart) ?? 0;

      final concMl =
          double.tryParse(mlPart) ?? 5;

      double doseMl =
          (doseMg / concMg) * concMl;

      // ROUND CLINICAL STYLE

      if (doseMl <= 2.5) {

        doseMl = 2.5;

      } else if (doseMl <= 5) {

        doseMl = 5;

      } else {

        doseMl =
            (doseMl / 5).round() * 5;
      }

      final totalMl =
          doseMl * 3 * duration;

      final bottleCount =
          (totalMl / 60).ceil();

      calculatedDose =
          '${doseMl.toStringAsFixed(0)} mL per dose';

      smartSigna =
          'S 3 dd ${doseMl.toStringAsFixed(0)} mL p.c';

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

      double tabDose =
          doseMg / strength;

      if (tabDose <= 0.25) {

        tabDose = 0.25;

      } else if (tabDose <= 0.5) {

        tabDose = 0.5;

      } else if (tabDose <= 0.75) {

        tabDose = 0.75;

      } else if (tabDose <= 1) {

        tabDose = 1;

      } else {

        tabDose =
            tabDose.roundToDouble();
      }

      String tabText = '';

      if (tabDose == 0.25) {

        tabText = '¼ tab';

      } else if (tabDose == 0.5) {

        tabText = '½ tab';

      } else if (tabDose == 0.75) {

        tabText = '¾ tab';

      } else {

        tabText =
            '${tabDose.toStringAsFixed(0)} tab';
      }

      final totalTab =
          (tabDose * 3 * duration).ceil();

      calculatedDose =
          '${doseMg.toStringAsFixed(0)} mg per dose';

      smartSigna =
          'S 3 dd $tabText p.c';

      qtyText =
          'No. ${toRoman(totalTab)}';
    }

    setState(() {

      result = calculatedDose;

      clinicalNote =
          'Max daily dose: $note';

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

      labelStyle: TextStyle(
        color:
            Colors.white.withOpacity(0.7),
      ),

      filled: true,

      fillColor:
          Colors.white.withOpacity(0.05),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: BorderSide(
          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),

        borderSide: const BorderSide(
          color: Colors.cyanAccent,
        ),
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
                  CircularProgressIndicator(
                color:
                    Colors.cyanAccent,
              ),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(

                    'Pediatric Dose',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  DropdownButtonFormField<String>(

                    value: selectedCategory,

                    dropdownColor:
                        const Color(0xff10192d),

                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),

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

                      if (value != null) {

                        selectedCategory = value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(

                    value:
                        selectedDosageForm,

                    dropdownColor:
                        const Color(0xff10192d),

                    style:
                        const TextStyle(
                      color: Colors.white,
                    ),

                    decoration:
                        cyberInput(
                      'Dosage Form',
                    ),

                    items:
                        dosageForms.map((e) {

                      return DropdownMenuItem(
                        value: e,
                        child:
                            Text(e.toUpperCase()),
                      );
                    }).toList(),

                    onChanged: (value) {

                      if (value != null) {

                        selectedDosageForm = value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  InkWell(

                    borderRadius:
                        BorderRadius.circular(20),

                    onTap: showDrugSearch,

                    child: Container(

                      width: double.infinity,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),

                      decoration: BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(20),

                        color:
                            Colors.white.withOpacity(0.05),

                        border: Border.all(
                          color:
                              Colors.white.withOpacity(0.08),
                        ),
                      ),

                      child: Row(

                        children: [

                          const Icon(
                            Icons.search_rounded,
                            color:
                                Colors.cyanAccent,
                          ),

                          const SizedBox(width: 14),

                          Expanded(

                            child: Text(

                              selectedDrug == null
                                  ? 'Search Drug'
                                  : '${selectedDrug!['name']} (${selectedDrug!['concentration']})',

                              overflow:
                                  TextOverflow.ellipsis,

                              style:
                                  const TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.cyanAccent,

                        foregroundColor:
                            Colors.black,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                      ),

                      onPressed:
                          calculateDose,

                      child: const Text(

                        'CALCULATE',

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (result.isNotEmpty)
                    buildResultCard(),
                ],
              ),
            ),
    );
  }

  // =====================================================
  // RESULT CARD
  // =====================================================

  Widget buildResultCard() {

    return Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(28),

      decoration: BoxDecoration(

        borderRadius:
            BorderRadius.circular(30),

        color:
            Colors.white.withOpacity(0.05),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(

            'Calculated Dose',

            style: TextStyle(
              color:
                  Colors.cyanAccent,
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(

            result,

            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 28),

          const Text(

            'Generated Prescription',

            style: TextStyle(
              color:
                  Colors.orangeAccent,
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Container(

            width: double.infinity,

            padding:
                const EdgeInsets.all(20),

            decoration: BoxDecoration(

              borderRadius:
                  BorderRadius.circular(22),

              color:
                  Colors.white.withOpacity(0.04),
            ),

            child: Text(

              generatedPrescription,

              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.8,
              ),
            ),
          ),

          const SizedBox(height: 28),

          const Text(

            'Clinical Note',

            style: TextStyle(
              color:
                  Colors.orangeAccent,
              fontSize: 20,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(

            clinicalNote,

            style: TextStyle(
              color:
                  Colors.white.withOpacity(0.78),
              fontSize: 16,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}