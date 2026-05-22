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

  List<Map<String, dynamic>> drugs = [];
  List<Map<String, dynamic>> filteredDrugs = [];
  List<String> categories = [];

  final List<String> dosageForms = [
    'tablet',
    'syrup',
    'capsule',
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

  Future<void> loadDrugs() async {

    try {

      final data =
          await SupabaseService
              .getPediatricDrugs();

      drugs = data;

      categories = drugs
          .map((e) =>
              e['category'].toString())
          .toSet()
          .toList();

      categories.sort();

      if (categories.isNotEmpty) {
        selectedCategory =
            categories.first;
      }

      filterDrugs();

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  void filterDrugs() {

    filteredDrugs =
        drugs.where((drug) {

      final categoryMatch =
          drug['category']
                  .toString()
                  .toLowerCase() ==
              selectedCategory!
                  .toLowerCase();

      final dosageMatch =
          drug['dosage_form']
                  .toString()
                  .toLowerCase()
                  .trim() ==
              selectedDosageForm!
                  .toLowerCase()
                  .trim();

      return categoryMatch &&
          dosageMatch;

    }).toList();

    if (filteredDrugs.isNotEmpty) {

      selectedDrug =
          filteredDrugs.first;

    } else {

      selectedDrug = null;
    }

    setState(() {});
  }

  Future<void> showDrugSearch() async {

    TextEditingController searchController =
        TextEditingController();

    List<Map<String, dynamic>>
        tempList = List.from(
      filteredDrugs,
    );

    await showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder:
              (context, setStateDialog) {

            return AlertDialog(

              backgroundColor:
                  const Color(
                0xFF1E1E1E,
              ),

              title: const Text(

                'Search Drug',

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              content: SizedBox(

                width: double.maxFinite,

                height: 400,

                child: Column(

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
                          InputDecoration(

                        hintText:
                            'Search drug...',

                        hintStyle:
                            const TextStyle(
                          color:
                              Colors.white54,
                        ),

                        filled: true,

                        fillColor:
                            Colors.black26,

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),

                      onChanged: (value) {

                        setStateDialog(() {

                          tempList =
                              filteredDrugs
                                  .where(
                                      (drug) {

                            final text =
                                '${drug['name']} ${drug['dose']}'
                                    .toLowerCase();

                            return text
                                .contains(
                              value
                                  .toLowerCase(),
                            );

                          }).toList();
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    Expanded(

                      child: ListView.builder(

                        itemCount:
                            tempList.length,

                        itemBuilder:
                            (context,
                                index) {

                          final drug =
                              tempList[index];

                          return ListTile(

                            title: Text(

                              '${drug['name']} (${drug['dosage_form']})',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),

                            subtitle: Text(

                              '${drug['dose']}',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                              ),
                            ),

                            onTap: () {

                              setState(() {

                                selectedDrug =
                                    drug;
                              });

                              Navigator.pop(
                                  context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void calculateDose() {

    if (selectedDrug == null) {

      setState(() {
        result = 'Drug not found';
      });

      return;
    }

    final weight =
        double.tryParse(
      weightController.text,
    );

    if (weight == null ||
        weight <= 0) {

      setState(() {
        result = 'Invalid weight';
      });

      return;
    }

    final minDose =
        double.tryParse(
              selectedDrug![
                      'mg_per_kg_min']
                  .toString(),
            ) ??
            0;

    final maxDose =
        double.tryParse(
              selectedDrug![
                      'mg_per_kg_max']
                  .toString(),
            ) ??
            0;

    final syrupMg =
        double.tryParse(
              selectedDrug![
                      'syrup_mg']
                  .toString(),
            ) ??
            0;

    final syrupMl =
        double.tryParse(
              selectedDrug![
                      'syrup_ml']
                  .toString(),
            ) ??
            0;

    final dosageForm =
        selectedDrug![
                'dosage_form']
            .toString()
            .toLowerCase();

    final drugName =
        selectedDrug!['name']
            .toString();

    final note =
        selectedDrug!['note'] ?? '-';

    final minMg =
        weight * minDose;

    final maxMg =
        weight * maxDose;

    String calculatedDose = '';
    String smartSigna = '';

    if ((dosageForm == 'syrup' ||
            dosageForm == 'drops' ||
            dosageForm ==
                'suspension') &&
        syrupMg > 0 &&
        syrupMl > 0) {

      final minMl =
          (minMg / syrupMg) *
              syrupMl;

      final maxMl =
          (maxMg / syrupMg) *
              syrupMl;

      calculatedDose =
          '${minMl.toStringAsFixed(1)}–${maxMl.toStringAsFixed(1)} mL per dose';

      smartSigna =
          '3 dd ${minMl.toStringAsFixed(1)}–${maxMl.toStringAsFixed(1)} mL p.c';

    } else {

      final tabletStrength =
          double.tryParse(
                selectedDrug![
                        'dose']
                    .toString()
                    .replaceAll('mg', '')
                    .trim(),
              ) ??
              500;

      final maxTab =
          maxMg / tabletStrength;

      calculatedDose =
          '${minMg.toStringAsFixed(0)}–${maxMg.toStringAsFixed(0)} mg per dose';

      String tabText = '';

      if (maxTab <= 0.25) {

        tabText = '¼ tab';

      } else if (maxTab <= 0.5) {

        tabText = '½ tab';

      } else if (maxTab <= 0.75) {

        tabText = '¾ tab';

      } else if (maxTab <= 1) {

        tabText = '1 tab';

      } else if (maxTab <= 1.5) {

        tabText = '1½ tab';

      } else if (maxTab <= 2) {

        tabText = '2 tab';

      } else {

        tabText =
            '${maxTab.toStringAsFixed(1)} tab';
      }

      smartSigna =
          '3 dd $tabText p.c';
    }

    setState(() {

      result = calculatedDose;

      clinicalNote = note;

      generatedPrescription = '''

R/

$drugName

S:
$smartSigna

''';
    });
  }

  InputDecoration inputStyle(
      String label) {

    return InputDecoration(

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
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        title: const Text(
          'Pediatric Dose',
        ),

        backgroundColor:
            Colors.black,
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : SingleChildScrollView(

              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  DropdownButtonFormField<
                      String>(

                    value:
                        selectedCategory,

                    dropdownColor:
                        Colors.black,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        inputStyle(
                      'Category',
                    ),

                    items:
                        categories.map(
                            (e) {

                      return DropdownMenuItem(

                        value: e,

                        child: Text(e),
                      );
                    }).toList(),

                    onChanged: (value) {

                      if (value !=
                          null) {

                        selectedCategory =
                            value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<
                      String>(

                    value:
                        selectedDosageForm,

                    dropdownColor:
                        Colors.black,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        inputStyle(
                      'Dosage Form',
                    ),

                    items:
                        dosageForms.map(
                            (e) {

                      return DropdownMenuItem(

                        value: e,

                        child: Text(
                          e.toUpperCase(),
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {

                      if (value !=
                          null) {

                        selectedDosageForm =
                            value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  InkWell(

                    onTap:
                        showDrugSearch,

                    child: Container(

                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets
                              .symmetric(

                        horizontal: 15,
                        vertical: 18,
                      ),

                      decoration:
                          BoxDecoration(

                        color:
                            const Color(
                          0xFF1E1E1E,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),

                        border: Border.all(
                          color:
                              Colors.white24,
                        ),
                      ),

                      child: Row(

                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,

                        children: [

                          Expanded(

                            child: Text(

                              selectedDrug == null

                                  ? 'Select Drug'

                                  : '${selectedDrug!['name']} (${selectedDrug!['dose']})',

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,
                              ),
                            ),
                          ),

                          const Icon(

                            Icons.search,

                            color:
                                Colors.white70,
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
                        TextInputType
                            .number,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        inputStyle(
                      'Weight (kg)',
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 55,

                    child:
                        ElevatedButton(

                      style:
                          ElevatedButton
                              .styleFrom(

                        backgroundColor:
                            Colors
                                .cyanAccent,

                        foregroundColor:
                            Colors.black,
                      ),

                      onPressed:
                          calculateDose,

                      child:
                          const Text(

                        'CALCULATE',

                        style:
                            TextStyle(

                          fontSize:
                              18,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (result
                      .isNotEmpty)

                    Card(

                      color:
                          const Color(
                        0xFF1E1E1E,
                      ),

                      child:
                          Padding(

                        padding:
                            const EdgeInsets
                                .all(
                          20,
                        ),

                        child:
                            Column(

                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            const Text(

                              'Calculated Dose',

                              style:
                                  TextStyle(

                                color:
                                    Colors.cyanAccent,

                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(

                              result,

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white,

                                fontSize:
                                    18,
                              ),
                            ),

                            const SizedBox(height: 30),

                            const Text(

                              'Generated Prescription',

                              style:
                                  TextStyle(

                                color:
                                    Colors.orangeAccent,

                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(

                              width:
                                  double.infinity,

                              padding:
                                  const EdgeInsets
                                      .all(
                                15,
                              ),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors
                                        .black26,

                                borderRadius:
                                    BorderRadius.circular(
                                  12,
                                ),
                              ),

                              child:
                                  Text(

                                generatedPrescription,

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize:
                                      16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            const Text(

                              'Clinical Note',

                              style:
                                  TextStyle(

                                color:
                                    Colors.orangeAccent,

                                fontSize:
                                    20,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(

                              clinicalNote,

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white70,

                                fontSize:
                                    16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}