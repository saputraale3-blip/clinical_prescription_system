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
      TextEditingController(
    text: '5',
  );

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

  // =====================================================
  // LOAD DRUGS
  // =====================================================

  Future<void> loadDrugs() async {

    try {

      final data =
          await SupabaseService
              .getPediatricDrugs();

      drugs = data;

      categories = drugs
          .map(
            (e) => e['category']
                .toString(),
          )
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

  // =====================================================
  // FILTER
  // =====================================================

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

  // =====================================================
  // SEARCH DIALOG
  // =====================================================

  Future<void> showDrugSearch() async {

    final searchController =
        TextEditingController();

    List<Map<String, dynamic>>
        tempList = List.from(
      filteredDrugs,
    );

    await showDialog(

      context: context,

      barrierColor:
          Colors.black54,

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

                child:
                    BackdropFilter(

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

                      border:
                          Border.all(
                        color: Colors
                            .white
                            .withOpacity(
                          0.08,
                        ),
                      ),
                    ),

                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,

                      children: [

                        Row(

                          children: [

                            const Icon(
                              Icons.search_rounded,
                              color:
                                  Colors.cyanAccent,
                            ),

                            const SizedBox(
                              width: 10,
                            ),

                            const Text(

                              'Search Drug',

                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 22,
                        ),

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
                            'Search medicine...',
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
                                        '${drug['name']} ${drug['dose']}'
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

                              return Container(

                                margin:
                                    const EdgeInsets.only(
                                  bottom:
                                      12,
                                ),

                                decoration:
                                    BoxDecoration(

                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),

                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.04,
                                  ),
                                ),

                                child:
                                    ListTile(

                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        18,
                                    vertical:
                                        10,
                                  ),

                                  leading:
                                      Container(

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
                                          Colors
                                              .cyanAccent,
                                          Colors
                                              .blueAccent,
                                        ],
                                      ),
                                    ),

                                    child:
                                        const Icon(
                                      Icons
                                          .medication_rounded,
                                      color:
                                          Colors.white,
                                    ),
                                  ),

                                  title:
                                      Text(

                                    '${drug['name']} (${drug['dose']})',

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
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
        double.tryParse(
      weightController.text,
    );

    final duration =
        double.tryParse(
      durationController.text,
    );

    if (weight == null ||
        weight <= 0) {

      setState(() {
        result = 'Invalid weight';
      });

      return;
    }

    if (duration == null ||
        duration <= 0) {

      setState(() {
        result = 'Invalid duration';
      });

      return;
    }

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

    final maxMg =
        weight * maxDose;

    String calculatedDose = '';
    String smartSigna = '';
    String qtyText = '';

    // =====================================================
    // SYRUP / DROPS
    // =====================================================

    if ((dosageForm == 'syrup' ||
            dosageForm == 'drops' ||
            dosageForm == 'suspension') &&
        syrupMg > 0 &&
        syrupMl > 0) {

      double doseMl =
          ((maxMg / syrupMg) *
                  syrupMl);

      // AUTO ROUNDING KLINIS

      if (doseMl <= 1) {

        doseMl =
            (doseMl * 10)
                    .round() /
                10;

      } else {

        doseMl =
            (doseMl * 2)
                    .round() /
                2;
      }

      final totalMl =
          doseMl *
              3 *
              duration;

      final bottleSize =
          60;

      final bottleCount =
          (totalMl /
                  bottleSize)
              .ceil();

      calculatedDose =
          '${doseMl.toStringAsFixed(1)} mL per dose';

      smartSigna =
          '3 dd ${doseMl.toStringAsFixed(1)} mL p.c x ${duration.toInt()} days';

      qtyText =
          'fl No. ${toRoman(bottleCount)}';
    }

    // =====================================================
    // TABLET / CAPSULE
    // =====================================================

    else {

      final tabletStrength =
          double.tryParse(
                selectedDrug![
                        'dose']
                    .toString()
                    .replaceAll(
                        'mg', '')
                    .trim(),
              ) ??
              500;

      double tabPerDose =
          maxMg /
              tabletStrength;

      // CLINICAL ROUNDING

      if (tabPerDose <=
          0.25) {

        tabPerDose = 0.25;

      } else if (tabPerDose <=
          0.5) {

        tabPerDose = 0.5;

      } else if (tabPerDose <=
          0.75) {

        tabPerDose = 0.75;

      } else if (tabPerDose <=
          1) {

        tabPerDose = 1;

      } else if (tabPerDose <=
          1.5) {

        tabPerDose = 1.5;

      } else if (tabPerDose <=
          2) {

        tabPerDose = 2;

      } else {

        tabPerDose =
            tabPerDose.roundToDouble();
      }

      String tabText = '';

      if (tabPerDose ==
          0.25) {

        tabText = '¼ tab';

      } else if (tabPerDose ==
          0.5) {

        tabText = '½ tab';

      } else if (tabPerDose ==
          0.75) {

        tabText = '¾ tab';

      } else if (tabPerDose ==
          1) {

        tabText = '1 tab';

      } else if (tabPerDose ==
          1.5) {

        tabText = '1½ tab';

      } else {

        tabText =
            '${tabPerDose.toStringAsFixed(0)} tab';
      }

      final exactQty =
          tabPerDose *
              3 *
              duration;

      final finalQty =
          exactQty.ceil();

      calculatedDose =
          '${maxMg.toStringAsFixed(0)} mg per dose';

      smartSigna =
          '3 dd $tabText p.c x ${duration.toInt()} days';

      qtyText =
          'No. ${toRoman(finalQty)}';
    }

    setState(() {

      result =
          calculatedDose;

      clinicalNote =
          note;

      generatedPrescription = '''

R/

$drugName

$qtyText

S:

$smartSigna

''';
    });
  }

  // =====================================================
  // INPUT STYLE
  // =====================================================

  InputDecoration cyberInput(
      String label) {

    return InputDecoration(

      labelText: label,

      labelStyle:
          TextStyle(
        color: Colors.white
            .withOpacity(
          0.7,
        ),
      ),

      filled: true,

      fillColor:
          Colors.white
              .withOpacity(
        0.05,
      ),

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide(
          color: Colors.white
              .withOpacity(
            0.08,
          ),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide:
            BorderSide(
          color: Colors.white
              .withOpacity(
            0.08,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        borderSide:
            const BorderSide(
          color:
              Colors.cyanAccent,
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

      backgroundColor:
          Colors.transparent,

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
                  const EdgeInsets.all(
                24,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(

                    'Pediatric Dose',

                    style: TextStyle(
                      color:
                          Colors.white,
                      fontSize: 38,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  DropdownButtonFormField<
                      String>(

                    value:
                        selectedCategory,

                    dropdownColor:
                        const Color(
                      0xff10192d,
                    ),

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        cyberInput(
                      'Category',
                    ),

                    items:
                        categories.map(
                      (e) {

                        return DropdownMenuItem(
                          value: e,

                          child: Text(
                            e,
                          ),
                        );
                      },
                    ).toList(),

                    onChanged:
                        (value) {

                      if (value !=
                          null) {

                        selectedCategory =
                            value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  DropdownButtonFormField<
                      String>(

                    value:
                        selectedDosageForm,

                    dropdownColor:
                        const Color(
                      0xff10192d,
                    ),

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        cyberInput(
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
                      },
                    ).toList(),

                    onChanged:
                        (value) {

                      if (value !=
                          null) {

                        selectedDosageForm =
                            value;

                        filterDrugs();
                      }
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  InkWell(

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    onTap:
                        showDrugSearch,

                    child:
                        Container(

                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal:
                            18,
                        vertical:
                            18,
                      ),

                      decoration:
                          BoxDecoration(

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),

                        color: Colors
                            .white
                            .withOpacity(
                          0.05,
                        ),

                        border:
                            Border.all(
                          color: Colors
                              .white
                              .withOpacity(
                            0.08,
                          ),
                        ),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons
                                .search_rounded,
                            color:
                                Colors.cyanAccent,
                          ),

                          const SizedBox(
                            width: 14,
                          ),

                          Expanded(

                            child: Text(

                              selectedDrug ==
                                      null
                                  ? 'Search Drug'
                                  : '${selectedDrug!['name']} (${selectedDrug!['dose']})',

                              overflow:
                                  TextOverflow
                                      .ellipsis,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

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
                        cyberInput(
                      'Weight (kg)',
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextField(

                    controller:
                        durationController,

                    keyboardType:
                        TextInputType
                            .number,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        cyberInput(
                      'Duration (days)',
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  SizedBox(

                    width:
                        double.infinity,

                    height: 58,

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

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                        ),
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

                  const SizedBox(
                    height: 30,
                  ),

                  if (result
                      .isNotEmpty)

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

      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        28,
      ),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          30,
        ),

        color:
            Colors.white
                .withOpacity(
          0.05,
        ),

        border:
            Border.all(
          color:
              Colors.white
                  .withOpacity(
            0.08,
          ),
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment
                .start,

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

          const SizedBox(
            height: 12,
          ),

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

          const SizedBox(
            height: 28,
          ),

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

          const SizedBox(
            height: 12,
          ),

          Container(

            width:
                double.infinity,

            padding:
                const EdgeInsets.all(
              20,
            ),

            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              color: Colors
                  .white
                  .withOpacity(
                0.04,
              ),
            ),

            child: Text(

              generatedPrescription,

              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize:
                    16,
                height:
                    1.8,
              ),
            ),
          ),

          const SizedBox(
            height: 28,
          ),

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

          const SizedBox(
            height: 12,
          ),

          Text(

            clinicalNote,

            style:
                TextStyle(
              color: Colors
                  .white
                  .withOpacity(
                0.78,
              ),

              fontSize:
                  16,

              height:
                  1.8,
            ),
          ),
        ],
      ),
    );
  }
}