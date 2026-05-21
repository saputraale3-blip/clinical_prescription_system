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

  // =========================
  // LOAD DRUGS
  // =========================

  Future<void> loadDrugs() async {

    try {

      final data =
          await SupabaseService
              .getDrugs();

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
    }

    catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  // =========================
  // FILTER DRUG
  // =========================

  void filterDrugs() {

    filteredDrugs =
        drugs.where((drug) {

      final categoryMatch =
          drug['category']
                  .toString()
                  .toLowerCase() ==

              selectedCategory!
                  .toLowerCase();

      return categoryMatch;

    }).toList();

    if (filteredDrugs.isNotEmpty) {

      selectedDrug =
          filteredDrugs.first;
    }

    else {

      selectedDrug = null;
    }

    setState(() {});
  }

  // =========================
  // SEARCH DIALOG
  // =========================

  Future<void> showDrugSearch() async {

    TextEditingController
        searchController =
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
              (context,
                  setStateDialog) {

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

                      onChanged:
                          (value) {

                        setStateDialog(() {

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

                          }).toList();
                        });
                      },
                    ),

                    const SizedBox(
                        height: 15),

                    Expanded(

                      child:
                          ListView.builder(

                        itemCount:
                            tempList.length,

                        itemBuilder:
                            (context,
                                index) {

                          final drug =
                              tempList[index];

                          return ListTile(

                            title: Text(

                              '${drug['name']} (${drug['dose']})',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                              ),
                            ),

                            subtitle: Text(

                              '${drug['generic_name']}',

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

  // =========================
  // INPUT STYLE
  // =========================

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

        title:
            const Text(
          'Drug Database',
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

                children: [

                  // =========================
                  // CATEGORY
                  // =========================

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

                  const SizedBox(
                      height: 20),

                  // =========================
                  // SEARCHABLE DRUG
                  // =========================

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

                              selectedDrug ==
                                      null

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

                  const SizedBox(
                      height: 25),

                  // =========================
                  // DETAIL
                  // =========================

                  if (selectedDrug !=
                      null)

                    Card(

                      color:
                          const Color(
                        0xFF1E1E1E,
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
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

                            Text(

                              selectedDrug![
                                      'name']
                                  .toString(),

                              style:
                                  const TextStyle(

                                color:
                                    Colors.cyanAccent,

                                fontSize:
                                    24,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    20),

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
                                          'frequency'] ??
                                      '-',
                            ),

                            const SizedBox(
                                height:
                                    25),

                            const Text(

                              'Prescription',

                              style:
                                  TextStyle(

                                color:
                                    Colors.orangeAccent,

                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    10),

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

                              child: Text(

                                selectedDrug![
                                            'prescription_template'] ??
                                        '-',

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white,

                                  fontSize:
                                      16,

                                  height:
                                      1.6,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height:
                                    25),

                            const Text(

                              'Clinical Note',

                              style:
                                  TextStyle(

                                color:
                                    Colors.orangeAccent,

                                fontSize:
                                    18,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    10),

                            Text(

                              selectedDrug![
                                          'note'] ??
                                      '-',

                              style:
                                  const TextStyle(

                                color:
                                    Colors.white70,

                                fontSize:
                                    16,

                                height:
                                    1.6,
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

  // =========================
  // DETAIL ITEM
  // =========================

  Widget buildDetailItem(

    String title,

    String value,

  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
        bottom: 14,
      ),

      child: Row(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          SizedBox(

            width: 140,

            child: Text(

              '$title :',

              style:
                  const TextStyle(

                color:
                    Colors.white70,

                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
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

                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}