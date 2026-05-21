import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import 'edit_drug_page.dart';

class AdminDrugManagementPage
    extends StatefulWidget {

  const AdminDrugManagementPage({
    super.key,
  });

  @override
  State<AdminDrugManagementPage>
      createState() =>
          _AdminDrugManagementPageState();
}

class _AdminDrugManagementPageState
    extends State<
        AdminDrugManagementPage> {

  final TextEditingController
      searchController =
      TextEditingController();

  List<Map<String, dynamic>>
      drugs = [];

  List<Map<String, dynamic>>
      filteredDrugs = [];

  bool isLoading = true;

  String selectedFilter =
      'All Drugs';

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

      filteredDrugs =
          List.from(drugs);

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
  // SEARCH + FILTER
  // =========================

  void applyFilter() {

    List<Map<String, dynamic>>
        result = List.from(drugs);

    // FILTER PEDIATRIC

    if (selectedFilter ==
        'Pediatric') {

      result = result.where((drug) {

        return drug[
                'is_pediatric'] ==
            true;

      }).toList();
    }

    // FILTER DRUG DATABASE

    if (selectedFilter ==
        'Drug Database') {

      result = result.where((drug) {

        return drug[
                'is_pediatric'] !=
            true;

      }).toList();
    }

    // SEARCH

    final query =
        searchController.text
            .toLowerCase();

    result = result.where((drug) {

      final text =
          '${drug['name']} ${drug['generic_name']} ${drug['dose']}'
              .toLowerCase();

      return text.contains(query);

    }).toList();

    setState(() {

      filteredDrugs = result;
    });
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteDrug(
    int id,
  ) async {

    final confirm =
        await showDialog(

      context: context,

      builder: (_) {

        return AlertDialog(

          title: const Text(
            'Delete Drug',
          ),

          content: const Text(
            'Are you sure?',
          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );
              },

              child: const Text(
                'Cancel',
              ),
            ),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );
              },

              child: const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {

      await SupabaseService
          .deleteDrug(id);

      loadDrugs();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content: Text(
            'Drug deleted',
          ),
        ),
      );
    }

    catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  // =========================
  // BUILD
  // =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        title: const Text(
          'Drug Management',
        ),

        backgroundColor:
            Colors.black,
      ),

      body:

          isLoading

              ? const Center(

                  child:
                      CircularProgressIndicator(),
                )

              : Column(

                  children: [

                    // =========================
                    // SEARCH
                    // =========================

                    Padding(

                      padding:
                          const EdgeInsets.all(
                        15,
                      ),

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
                              const TextStyle(
                            color:
                                Colors.white54,
                          ),

                          prefixIcon:
                              const Icon(

                            Icons.search,

                            color:
                                Colors.white70,
                          ),

                          filled: true,

                          fillColor:
                              const Color(
                            0xFF1E1E1E,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),

                        onChanged: (value) {

                          applyFilter();
                        },
                      ),
                    ),

                    // =========================
                    // FILTER
                    // =========================

                    Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),

                      child:
                          DropdownButtonFormField<
                              String>(

                        value:
                            selectedFilter,

                        dropdownColor:
                            Colors.black,

                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                        ),

                        decoration:
                            InputDecoration(

                          filled: true,

                          fillColor:
                              const Color(
                            0xFF1E1E1E,
                          ),

                          border:
                              OutlineInputBorder(

                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),

                        items: [

                          'All Drugs',

                          'Drug Database',

                          'Pediatric',

                        ].map((e) {

                          return DropdownMenuItem(

                            value: e,

                            child: Text(e),
                          );
                        }).toList(),

                        onChanged: (value) {

                          selectedFilter =
                              value!;

                          applyFilter();
                        },
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    // =========================
                    // LIST
                    // =========================

                    Expanded(

                      child: ListView.builder(

                        itemCount:
                            filteredDrugs
                                .length,

                        itemBuilder:
                            (context,
                                index) {

                          final drug =
                              filteredDrugs[
                                  index];

                          return Card(

                            color:
                                const Color(
                              0xFF1E1E1E,
                            ),

                            margin:
                                const EdgeInsets.symmetric(

                              horizontal:
                                  15,

                              vertical: 8,
                            ),

                            child:
                                ListTile(

                              title: Text(

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

                                '${drug['generic_name']} • ${drug['dose']}',

                                style:
                                    const TextStyle(

                                  color:
                                      Colors.white70,
                                ),
                              ),

                              trailing:
                                  Row(

                                mainAxisSize:
                                    MainAxisSize.min,

                                children: [

                                  IconButton(

  onPressed: () async {

    await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => EditDrugPage(
          drug: drug,
        ),
      ),
    );

    loadDrugs();
  },

  icon: const Icon(

    Icons.edit,

    color: Colors.orange,
  ),
),


                                  IconButton(

                                    onPressed: () {

                                      deleteDrug(
                                        drug['id'],
                                      );
                                    },

                                    icon:
                                        const Icon(

                                      Icons.delete,

                                      color:
                                          Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}