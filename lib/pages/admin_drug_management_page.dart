import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDrugManagementPage extends StatefulWidget {
  const AdminDrugManagementPage({super.key});

  @override
  State<AdminDrugManagementPage> createState() =>
      _AdminDrugManagementPageState();
}

class _AdminDrugManagementPageState
    extends State<AdminDrugManagementPage> {

  final supabase = Supabase.instance.client;

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> drugs = [];
  List<Map<String, dynamic>> filteredDrugs = [];

  bool isLoading = true;

  String selectedFilter = 'All Drugs';

  final List<String> categories = [

    'Antibiotic',
    'Analgesic',
    'Antifungal',
    'Antiviral',
    'Antihistamine',
    'Anti-inflammatory',
    'Gastrointestinal',
    'Supplement',
    'Others',
  ];

  final List<String> dosageForms = [

    'Tablet',
    'Capsule',
    'Syrup',
    'Drops',
    'Suspension',

  ].toSet().toList();

  @override
  void initState() {
    super.initState();
    loadDrugs();
  }

  // =====================================================
  // NORMALIZE DOSAGE FORM
  // =====================================================

  String normalizeDosageForm(
      String value) {

    final v =
        value
            .trim()
            .toLowerCase();

    switch (v) {

      case 'tablet':
        return 'Tablet';

      case 'capsule':
        return 'Capsule';

      case 'syrup':
        return 'Syrup';

      case 'drops':
        return 'Drops';

      case 'suspension':
        return 'Suspension';

      default:
        return 'Tablet';
    }
  }

  // =====================================================
  // LOAD DRUGS
  // =====================================================

  Future<void> loadDrugs() async {

    setState(() {
      isLoading = true;
    });

    try {

      List<Map<String, dynamic>> result = [];

      if (selectedFilter ==
          'All Drugs') {

        final general =
            await supabase
                .from('drugs')
                .select();

        final pediatric =
            await supabase
                .from('pediatric_drugs')
                .select();

        result = [

          ...List<Map<String, dynamic>>.from(
            general,
          ),

          ...List<Map<String, dynamic>>.from(
            pediatric,
          ),
        ];
      }

      else if (selectedFilter ==
          'Drug Database') {

        final general =
            await supabase
                .from('drugs')
                .select();

        result =
            List<Map<String, dynamic>>.from(
          general,
        );
      }

      else {

        final pediatric =
            await supabase
                .from('pediatric_drugs')
                .select();

        result =
            List<Map<String, dynamic>>.from(
          pediatric,
        );
      }

      drugs = result;

      applySearch();

    } catch (e) {

      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  // =====================================================
  // SEARCH
  // =====================================================

  void applySearch() {

    final query =
        searchController.text
            .toLowerCase();

    filteredDrugs = drugs.where((drug) {

      final name =
          drug['name']
                  ?.toString()
                  .toLowerCase() ??
              '';

      return name.contains(query);

    }).toList();

    setState(() {});
  }

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> deleteDrug(
      Map<String, dynamic> drug) async {

    try {

      final isPediatric =
          drug.containsKey(
              'mg_per_kg_min');

      final table =
          isPediatric
              ? 'pediatric_drugs'
              : 'drugs';

      await supabase
          .from(table)
          .delete()
          .eq('id', drug['id']);

      await loadDrugs();

      if (mounted) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
            content:
                Text('Drug deleted'),
          ),
        );
      }

    } catch (e) {

      debugPrint(e.toString());
    }
  }

  // =====================================================
  // EDIT DIALOG
  // =====================================================

  Future<void> showEditDialog(
      Map<String, dynamic> drug) async {

    final nameController =
        TextEditingController(
      text:
          drug['name']?.toString() ??
              '',
    );

    final doseController =
        TextEditingController(
      text:
          drug['dose']?.toString() ??
              '',
    );

    final noteController =
        TextEditingController(
      text:
          drug['note']?.toString() ??
              '',
    );

    String selectedCategory =
        drug['category']
                ?.toString() ??
            categories.first;

    String selectedDosageForm =
        normalizeDosageForm(
      drug['dosage_form']
              ?.toString() ??
          'Tablet',
    );

    final isPediatric =
        drug.containsKey(
            'mg_per_kg_min');

    await showDialog(

      context: context,

      builder: (context) {

        return StatefulBuilder(

          builder:
              (context,
                  setStateDialog) {

            return Dialog(

              backgroundColor:
                  const Color(
                0xff10192d,
              ),

              child:
                  SingleChildScrollView(

                child: Padding(

                  padding:
                      const EdgeInsets.all(
                    24,
                  ),

                  child: Column(

                    mainAxisSize:
                        MainAxisSize.min,

                    children: [

                      const Text(

                        'Edit Drug',

                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      buildInput(
                        controller:
                            nameController,
                        label:
                            'Drug Name',
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      DropdownButtonFormField<
                          String>(

                        value:
                            categories.contains(
                                    selectedCategory)
                                ? selectedCategory
                                : null,

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
                            inputDecoration(
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
                          },
                        ).toList(),

                        onChanged:
                            (value) {

                          if (value !=
                              null) {

                            setStateDialog(
                              () {

                                selectedCategory =
                                    value;
                              },
                            );
                          }
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      buildInput(
                        controller:
                            doseController,
                        label: 'Dose',
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      DropdownButtonFormField<
                          String>(

                        value:
                            dosageForms.contains(
                                    selectedDosageForm)
                                ? selectedDosageForm
                                : null,

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
                            inputDecoration(
                          'Dosage Form',
                        ),

                        items:
                            dosageForms.map(
                          (form) {

                            return DropdownMenuItem<
                                String>(
                              value: form,
                              child:
                                  Text(form),
                            );
                          },
                        ).toList(),

                        onChanged:
                            (value) {

                          if (value !=
                              null) {

                            setStateDialog(
                              () {

                                selectedDosageForm =
                                    value;
                              },
                            );
                          }
                        },
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      buildInput(
                        controller:
                            noteController,
                        label: 'Note',
                        maxLines: 3,
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Row(

                        children: [

                          Expanded(

                            child:
                                ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red,
                              ),

                              onPressed:
                                  () {

                                Navigator.pop(
                                    context);
                              },

                              child:
                                  const Text(
                                'Cancel',
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 16,
                          ),

                          Expanded(

                            child:
                                ElevatedButton(

                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors
                                        .cyanAccent,

                                foregroundColor:
                                    Colors.black,
                              ),

                              onPressed:
                                  () async {

                                try {

                                  final table =
                                      isPediatric
                                          ? 'pediatric_drugs'
                                          : 'drugs';

                                  await supabase
                                      .from(
                                          table)
                                      .update({

                                    'name':
                                        nameController
                                            .text,

                                    'category':
                                        selectedCategory,

                                    'dose':
                                        doseController
                                            .text,

                                    'dosage_form':
                                        selectedDosageForm,

                                    'note':
                                        noteController
                                            .text,

                                  })
                                      .eq(
                                    'id',
                                    drug['id'],
                                  );

                                  Navigator.pop(
                                      context);

                                  await loadDrugs();

                                  if (mounted) {

                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(

                                      const SnackBar(
                                        content:
                                            Text(
                                          'Drug updated successfully',
                                        ),
                                      ),
                                    );
                                  }

                                } catch (e) {

                                  debugPrint(
                                      e.toString());
                                }
                              },

                              child:
                                  const Text(
                                'Save',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
  // INPUT DECORATION
  // =====================================================

  InputDecoration inputDecoration(
      String label) {

    return InputDecoration(

      labelText: label,

      labelStyle:
          TextStyle(
        color: Colors.white
            .withOpacity(0.7),
      ),

      filled: true,

      fillColor:
          Colors.white
              .withOpacity(0.05),

      border:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),
    );
  }

  Widget buildInput({

    required TextEditingController
        controller,

    required String label,

    int maxLines = 1,

  }) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration:
          inputDecoration(label),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff081221),

      floatingActionButton:
          FloatingActionButton(

        backgroundColor:
            Colors.cyanAccent,

        child: const Icon(
          Icons.refresh,
          color: Colors.black,
        ),

        onPressed: loadDrugs,
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(24),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const SizedBox(
              height: 20,
            ),

            const Text(

              'Drug Management',

              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(

              'Manage all medicine database',

              style: TextStyle(
                color: Colors.white
                    .withOpacity(0.7),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Row(

              children: [

                Expanded(

                  child: TextField(

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
                          TextStyle(
                        color: Colors
                            .white
                            .withOpacity(
                          0.5,
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
                          16,
                        ),
                      ),
                    ),

                    onChanged: (v) {
                      applySearch();
                    },
                  ),
                ),

                const SizedBox(
                  width: 20,
                ),

                SizedBox(

                  width: 250,

                  child:
                      DropdownButtonFormField<
                          String>(

                    value:
                        selectedFilter,

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
                        InputDecoration(

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
                          16,
                        ),
                      ),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value:
                            'All Drugs',
                        child: Text(
                          'All Drugs',
                        ),
                      ),

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
                        (value) async {

                      selectedFilter =
                          value!;

                      await loadDrugs();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),

            Expanded(

              child: isLoading

                  ? const Center(
                      child:
                          CircularProgressIndicator(),
                    )

                  : filteredDrugs
                          .isEmpty

                      ? const Center(

                          child: Text(

                            'No drugs found',

                            style: TextStyle(
                              color: Colors
                                  .white54,
                              fontSize:
                                  20,
                            ),
                          ),
                        )

                      : GridView.builder(

                          itemCount:
                              filteredDrugs
                                  .length,

                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(

                            crossAxisCount:
                                2,

                            crossAxisSpacing:
                                20,

                            mainAxisSpacing:
                                20,

                            childAspectRatio:
                                1.8,
                          ),

                          itemBuilder:
                              (
                                context,
                                index,
                              ) {

                            final drug =
                                filteredDrugs[
                                    index];

                            return Container(

                              padding:
                                  const EdgeInsets.all(
                                20,
                              ),

                              decoration:
                                  BoxDecoration(

                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.05,
                                ),

                                borderRadius:
                                    BorderRadius.circular(
                                  24,
                                ),
                              ),

                              child:
                                  Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                children: [

                                  Row(

                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,

                                    children: [

                                      Expanded(

                                        child:
                                            Text(

                                          drug['name']
                                              .toString(),

                                          overflow:
                                              TextOverflow
                                                  .ellipsis,

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.white,
                                            fontSize:
                                                24,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      Row(

                                        children: [

                                          IconButton(

                                            onPressed:
                                                () {

                                              showEditDialog(
                                                  drug);
                                            },

                                            icon:
                                                const Icon(
                                              Icons
                                                  .edit,
                                              color:
                                                  Colors.cyanAccent,
                                            ),
                                          ),

                                          IconButton(

                                            onPressed:
                                                () {

                                              deleteDrug(
                                                  drug);
                                            },

                                            icon:
                                                const Icon(
                                              Icons
                                                  .delete,
                                              color:
                                                  Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height:
                                        10,
                                  ),

                                  Text(

                                    'Category: ${drug['category'] ?? '-'}',

                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        6,
                                  ),

                                  Text(

                                    'Dose: ${drug['dose'] ?? '-'}',

                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height:
                                        6,
                                  ),

                                  Text(

                                    'Form: ${drug['dosage_form'] ?? '-'}',

                                    style:
                                        TextStyle(
                                      color: Colors
                                          .white
                                          .withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}