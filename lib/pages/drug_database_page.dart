import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class DrugDatabasePage extends StatefulWidget {
  const DrugDatabasePage({super.key});

  @override
  State<DrugDatabasePage> createState() =>
      _DrugDatabasePageState();
}

class _DrugDatabasePageState
    extends State<DrugDatabasePage> {
  List<Map<String, dynamic>> drugs = [];

  List<Map<String, dynamic>>
      filteredDrugs = [];

  List<String> categories = [];

  String? selectedCategory;

  Map<String, dynamic>? selectedDrug;

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
              .getDrugs();

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
      return drug['category']
              .toString()
              .toLowerCase() ==
          selectedCategory!
              .toLowerCase();
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
                                        '${drug['name']} ${drug['generic_name']} ${drug['dose']}'
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
                                tempList
                                    .length,

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

                                  subtitle:
                                      Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top:
                                          5,
                                    ),

                                    child:
                                        Text(
                                      drug['generic_name'] ??
                                          '-',

                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white
                                            .withOpacity(
                                          0.65,
                                        ),
                                      ),
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
  // PRESCRIPTION BUILDER
  // =====================================================

  String buildPrescription() {
    if (selectedDrug == null) {
      return '-';
    }

    final drug =
        selectedDrug!;

    final dosageForm =
        drug['dosage_form']
            .toString()
            .toLowerCase();

    final frequency =
        drug['frequency_signa'] ??
            '-';

    final unit =
        drug['signa_unit'] ??
            '-';

    final note =
        drug['signa_note'] ??
            '';

    final qty =
        drug['qty_default']
            ?.toString() ??
            '10';

    String formText = '';

    if (dosageForm.contains(
        'tablet')) {
      formText = 'Tab';
    } else if (dosageForm.contains(
        'capsule')) {
      formText = 'Caps';
    } else if (dosageForm.contains(
        'syrup')) {
      formText = 'Fl';
    } else if (dosageForm.contains(
        'cream')) {
      formText = 'Ung';
    } else {
      formText = dosageForm;
    }

    return '''

R/

${drug['name']} ${drug['dose']}

$formText No. $qty

S $frequency $unit I $note

''';
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
    final width =
        MediaQuery.of(context)
            .size
            .width;

    final bool isMobile =
        width < 700;

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
                  EdgeInsets.all(
                isMobile
                    ? 16
                    : 26,
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
                              selectedDrug == null
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
                    height: 28,
                  ),

                  if (selectedDrug !=
                      null)
                    buildDetailCard(
                      isMobile,
                    ),
                ],
              ),
            ),
    );
  }

  // =====================================================
  // DETAIL CARD
  // =====================================================

  Widget buildDetailCard(
      bool isMobile) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(
        32,
      ),

      child: BackdropFilter(
        filter:
            ImageFilter.blur(
          sigmaX: 18,
          sigmaY: 18,
        ),

        child: Container(
          width: double.infinity,

          padding:
              EdgeInsets.all(
            isMobile
                ? 20
                : 28,
          ),

          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              32,
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

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              Text(
                selectedDrug![
                    'name'],

                style:
                    const TextStyle(
                  color:
                      Colors.cyanAccent,

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              buildDetailItem(
                'Generic Name',
                selectedDrug![
                        'generic_name'] ??
                    '-',
              ),

              buildDetailItem(
                'Category',
                selectedDrug![
                        'category'] ??
                    '-',
              ),

              buildDetailItem(
                'Dosage Form',
                selectedDrug![
                        'dosage_form'] ??
                    '-',
              ),

              buildDetailItem(
                'Dose',
                selectedDrug![
                        'dose'] ??
                    '-',
              ),

              buildDetailItem(
                'Frequency',
                selectedDrug![
                        'frequency_signa'] ??
                    '-',
              ),

              const SizedBox(
                height: 28,
              ),

              const Text(
                'Prescription',

                style: TextStyle(
                  color:
                      Colors.orangeAccent,

                  fontSize: 20,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

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
                    22,
                  ),

                  color: Colors
                      .white
                      .withOpacity(
                    0.04,
                  ),
                ),

                child: Text(
                  buildPrescription(),

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
                height: 14,
              ),

              Text(
                selectedDrug![
                        'note'] ??
                    '-',

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
        ),
      ),
    );
  }

  // =====================================================
  // DETAIL ITEM
  // =====================================================

  Widget buildDetailItem(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 16,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,

        children: [
          SizedBox(
            width: 150,

            child: Text(
              '$title :',

              style:
                  TextStyle(
                color: Colors
                    .white
                    .withOpacity(
                  0.65,
                ),

                fontWeight:
                    FontWeight.bold,

                fontSize:
                    15,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                color:
                    Colors.white,

                fontSize:
                    16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}