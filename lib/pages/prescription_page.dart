import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() =>
      _PrescriptionPageState();
}

class _PrescriptionPageState
    extends State<PrescriptionPage> {
  // =====================================================
  // CONTROLLERS
  // =====================================================

  final TextEditingController patientController =
      TextEditingController();

  final TextEditingController signaController =
      TextEditingController();

  final TextEditingController instructionController =
      TextEditingController();

  final TextEditingController qtyController =
      TextEditingController(text: '10');

  final TextEditingController searchController =
      TextEditingController();

  // =====================================================
  // STATES
  // =====================================================

  bool isLoading = true;

  String prescriptionType = 'Drug Database';

  String dosageForm = 'Tablet';

  String? selectedDrug;

  List<Map<String, dynamic>> selectedDrugs = [];

  // =====================================================
  // DATABASE
  // =====================================================

  List<Map<String, dynamic>> drugDatabase = [];

  List<Map<String, dynamic>>
      pediatricDatabase = [];

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {
    super.initState();

    loadDrugs();
  }

  // =====================================================
  // LOAD DATABASE
  // =====================================================

  Future<void> loadDrugs() async {
    try {
      final drugs =
          await SupabaseService.getDrugs();

      final pediatric =
          await SupabaseService
              .getPediatricDrugs();

      setState(() {
        drugDatabase = drugs;

        pediatricDatabase = pediatric;

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================================
  // ACTIVE DATABASE + FILTER
  // =====================================================

  List<Map<String, dynamic>>
      get activeDatabase {
    List<Map<String, dynamic>>
        database =
        prescriptionType ==
                'Pediatric'
            ? pediatricDatabase
            : drugDatabase;

    return database.where((drug) {
      final form =
          (drug['dosage_form'] ?? '')
              .toString()
              .toLowerCase();

      // TABLET

      if (dosageForm ==
          'Tablet') {
        return form.contains(
          'tablet',
        );
      }

      // CAPSULE

      if (dosageForm ==
          'Capsule') {
        return form.contains(
          'capsule',
        );
      }

      // SYRUP

      if (dosageForm ==
          'Syrup') {
        return form.contains(
              'syrup',
            ) ||
            form.contains(
              'drops',
            ) ||
            form.contains(
              'suspension',
            );
      }

      return true;
    }).toList();
  }

  // =====================================================
  // SEARCH DIALOG
  // =====================================================

  Future<void> showDrugSearch() async {
    List<Map<String, dynamic>>
        tempList =
        List.from(activeDatabase);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context,
                  setStateDialog) {
            return Dialog(
              backgroundColor:
                  Colors.transparent,
              child: Container(
                height: 600,
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xff111827,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    28,
                  ),
                  border:
                      Border.all(
                    color: Colors.white
                        .withOpacity(
                      0.08,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    // SEARCH

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
                        'Search Drug...',
                      ),
                      onChanged:
                          (value) {
                        setStateDialog(
                          () {
                            tempList =
                                activeDatabase
                                    .where(
                              (drug) {
                                final text =
                                    '${drug['name']} ${drug['dose']} ${drug['strength']}'
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

                    // LIST

                    Expanded(
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

                          String dose =
                              '';

                          // PEDIATRIC

                          if (prescriptionType ==
                              'Pediatric') {
                            final min =
                                drug[
                                    'mg_per_kg_min'];

                            final max =
                                drug[
                                    'mg_per_kg_max'];

                            final syrupMg =
                                drug[
                                    'syrup_mg'];

                            final syrupMl =
                                drug[
                                    'syrup_ml'];

                            dose =
                                '$min-$max mg/kg/day | $syrupMg mg / $syrupMl mL';
                          }

                          // GENERAL

                          else {
                            dose =
                                '${drug['strength'] ?? drug['dose'] ?? ''}';
                          }

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
                                0.03,
                              ),
                            ),
                            child:
                                ListTile(
                              leading:
                                  const Icon(
                                Icons
                                    .medication_rounded,
                                color:
                                    Colors.cyanAccent,
                              ),
                              title:
                                  Text(
                                drug['name']
                                    .toString(),
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text(
                                dose,
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.6,
                                  ),
                                ),
                              ),
                              onTap:
                                  () {
                                setState(
                                  () {
                                    selectedDrug =
                                        drug[
                                            'name'];

                                    dosageForm =
                                        drug['dosage_form'] ??
                                            dosageForm;
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
            );
          },
        );
      },
    );
  }

  // =====================================================
  // DOSAGE PREFIX
  // =====================================================

  String dosagePrefix(String form) {
    switch (form.toLowerCase()) {
      case 'tablet':
        return 'Tab';

      case 'capsule':
        return 'Caps';

      case 'syrup':
        return 'fl';

      default:
        return 'No.';
    }
  }

  // =====================================================
  // ADD DRUG
  // =====================================================

  void addDrug() {
    if (selectedDrug == null) return;

    final drug = activeDatabase.firstWhere(
      (e) => e['name'] == selectedDrug,
    );

    final qty =
        qtyController.text.isEmpty
            ? '10'
            : qtyController.text;

    String dose = '';

    // PEDIATRIC

    if (prescriptionType ==
        'Pediatric') {
      final min =
          drug['mg_per_kg_min'];

      final max =
          drug['mg_per_kg_max'];

      final syrupMg =
          drug['syrup_mg'];

      final syrupMl =
          drug['syrup_ml'];

      dose =
          '$min-$max mg/kg/day | $syrupMg mg/$syrupMl mL';
    }

    // GENERAL

    else {
      dose =
          '${drug['strength'] ?? drug['dose'] ?? ''}';
    }

    selectedDrugs.add({
      'name': drug['name'],
      'dose': dose,
      'form':
          drug['dosage_form'] ??
              dosageForm,
      'qty': qty,
      'signa': signaController.text,
      'instruction':
          instructionController.text,
    });

    signaController.clear();

    instructionController.clear();

    qtyController.text = '10';

    setState(() {});
  }

  // =====================================================
  // GENERATE PRESCRIPTION
  // =====================================================

  String generatePrescription() {
    String result = '';

    result +=
        'Patient : ${patientController.text}\n\n';

    for (var drug in selectedDrugs) {
      final prefix =
          dosagePrefix(
        drug['form'],
      );

      result +=
          'R/ ${drug['name']} ${drug['dose']} $prefix No. ${drug['qty']}\n';

      if ((drug['signa'] ?? '')
          .toString()
          .isNotEmpty) {
        result +=
            'S: ${drug['signa']}\n';
      }

      if ((drug['instruction'] ?? '')
          .toString()
          .isNotEmpty) {
        result +=
            '${drug['instruction']}\n';
      }

      result += '\n';
    }

    return result;
  }

  // =====================================================
  // INPUT STYLE
  // =====================================================

  InputDecoration cyberInput(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(
        color: Colors.white54,
      ),
      filled: true,
      fillColor:
          const Color(0xff111827),
      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        borderSide:
            BorderSide(
          color: Colors.white
              .withOpacity(0.1),
        ),
      ),
      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        borderSide:
            const BorderSide(
          color:
              Colors.cyanAccent,
          width: 2,
        ),
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xff020617),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color:
                    Colors.cyanAccent,
              ),
            )
          : SafeArea(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.all(
                  24,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    // TITLE

                    const Text(
                      'Prescription Generator',
                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      'Modern Clinical Prescription System',
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(
                          0.5,
                        ),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // FORM

                    Container(
                      padding:
                          const EdgeInsets.all(
                        24,
                      ),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          28,
                        ),
                        color: Colors
                            .white
                            .withOpacity(
                          0.03,
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
                        children: [
                          TextField(
                            controller:
                                patientController,
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),
                            decoration:
                                cyberInput(
                              'Patient Name',
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    DropdownButtonFormField<
                                        String>(
                                  value:
                                      prescriptionType,
                                  dropdownColor:
                                      const Color(
                                    0xff111827,
                                  ),
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                  decoration:
                                      cyberInput(
                                    'Prescription Type',
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value:
                                          'Drug Database',
                                      child: Text(
                                        'Drug Database',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Pediatric',
                                      child: Text(
                                        'Pediatric',
                                      ),
                                    ),
                                  ],
                                  onChanged:
                                      (value) {
                                    setState(() {
                                      prescriptionType =
                                          value!;
                                      selectedDrug =
                                          null;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(
                                width: 18,
                              ),

                              Expanded(
                                child:
                                    DropdownButtonFormField<
                                        String>(
                                  value:
                                      dosageForm,
                                  dropdownColor:
                                      const Color(
                                    0xff111827,
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
                                  items: const [
                                    DropdownMenuItem(
                                      value:
                                          'Tablet',
                                      child: Text(
                                        'Tablet',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Capsule',
                                      child: Text(
                                        'Capsule',
                                      ),
                                    ),
                                    DropdownMenuItem(
                                      value:
                                          'Syrup',
                                      child: Text(
                                        'Syrup',
                                      ),
                                    ),
                                  ],
                                  onChanged:
                                      (value) {
                                    setState(() {
                                      dosageForm =
                                          value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          // SEARCH DRUG

                          InkWell(
                            onTap:
                                showDrugSearch,
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
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
                                color:
                                    const Color(
                                  0xff111827,
                                ),
                                border:
                                    Border.all(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.1,
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
                                    child:
                                        Text(
                                      selectedDrug ==
                                              null
                                          ? 'Search Drug'
                                          : selectedDrug!,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
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
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          // SIGNA + QTY

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child:
                                    TextField(
                                  controller:
                                      signaController,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                  decoration:
                                      cyberInput(
                                    'Signa (3 dd tab I p.c)',
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 18,
                              ),

                              Expanded(
                                child:
                                    TextField(
                                  controller:
                                      qtyController,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                  ),
                                  decoration:
                                      cyberInput(
                                    'Qty',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          TextField(
                            controller:
                                instructionController,
                            maxLines: 3,
                            style:
                                const TextStyle(
                              color:
                                  Colors.white,
                            ),
                            decoration:
                                cyberInput(
                              'Additional Instruction',
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
                                ElevatedButton.icon(
                              onPressed:
                                  addDrug,
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .cyanAccent,
                                foregroundColor:
                                    Colors.black,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              icon:
                                  const Icon(
                                Icons.add,
                              ),
                              label:
                                  const Text(
                                'Add Drug',
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
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // DRUG LIST

                    if (selectedDrugs
                        .isNotEmpty)
                      Column(
                        children:
                            selectedDrugs
                                .asMap()
                                .entries
                                .map(
                          (entry) {
                            final index =
                                entry.key;

                            final drug =
                                entry.value;

                            return Container(
                              width:
                                  double.infinity,
                              margin:
                                  const EdgeInsets.only(
                                bottom: 16,
                              ),
                              padding:
                                  const EdgeInsets.all(
                                22,
                              ),
                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),
                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.03,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            Text(
                                          'R/ ${drug['name']} ${drug['dose']}',
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize:
                                                22,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                        onPressed:
                                            () {
                                          selectedDrugs
                                              .removeAt(
                                            index,
                                          );

                                          setState(
                                            () {},
                                          );
                                        },
                                        icon:
                                            const Icon(
                                          Icons
                                              .delete_rounded,
                                          color:
                                              Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        10,
                                  ),

                                  Text(
                                    '${drug['form']} • Qty ${drug['qty']}',
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.6,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        12,
                                  ),

                                  Text(
                                    'S: ${drug['signa']}',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.cyanAccent,
                                      fontSize:
                                          17,
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        10,
                                  ),

                                  Text(
                                    '${drug['instruction']}',
                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.7,
                                      ),
                                      height:
                                          1.6,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),

                    const SizedBox(
                      height: 28,
                    ),

                    // RESULT

                    if (selectedDrugs
                        .isNotEmpty)
                      Container(
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
                            28,
                          ),
                          color: Colors
                              .white
                              .withOpacity(
                            0.03,
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
                        child:
                            SelectableText(
                          generatePrescription(),
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 20,
                            height: 1.8,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}