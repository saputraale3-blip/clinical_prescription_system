import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/supabase_service.dart';
import 'edit_drug_page.dart';

class AdminDrugManagementPage extends StatefulWidget {
  const AdminDrugManagementPage({super.key});

  @override
  State<AdminDrugManagementPage> createState() =>
      _AdminDrugManagementPageState();
}

class _AdminDrugManagementPageState
    extends State<AdminDrugManagementPage> {
  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> drugs = [];
  List<Map<String, dynamic>> filteredDrugs = [];

  bool isLoading = true;

  String selectedFilter = 'All Drugs';

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
          await SupabaseService.getDrugs();

      drugs = List<Map<String, dynamic>>.from(
        data,
      );

      filteredDrugs = List.from(drugs);

      applyFilter();

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

  void applyFilter() {
    List<Map<String, dynamic>> result =
        List.from(drugs);

    // PEDIATRIC FILTER

    if (selectedFilter == 'Pediatric') {
      result = result.where((drug) {
        final type = drug['drug_type']
                ?.toString()
                .toLowerCase()
                .trim() ??
            '';

        return type.contains(
          'pediatric',
        );
      }).toList();
    }

    // GENERAL FILTER

    if (selectedFilter ==
        'Drug Database') {
      result = result.where((drug) {
        final type = drug['drug_type']
                ?.toString()
                .toLowerCase()
                .trim() ??
            '';

        return !type.contains(
          'pediatric',
        );
      }).toList();
    }

    // SEARCH

    final query =
        searchController.text.toLowerCase();

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

  // =====================================================
  // DELETE
  // =====================================================

  Future<void> deleteDrug(int id) async {
    try {
      await SupabaseService.deleteDrug(id);

      await loadDrugs();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Drug deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(e.toString()),
        ),
      );
    }
  }

  // =====================================================
  // CHIP
  // =====================================================

  Widget buildChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(50),
        color:
            Colors.white.withOpacity(0.06),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.cyanAccent,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.of(context).size.width;

    final bool isMobile = width < 700;

    return Scaffold(
      backgroundColor:
          const Color(0xff0B1220),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(
                color: Colors.cyanAccent,
              ),
            )
          : SingleChildScrollView(
              padding:
                  EdgeInsets.all(
                isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // =====================================================
                  // HEADER
                  // =====================================================

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(28),
                      color: Colors.white
                          .withOpacity(0.05),
                      border: Border.all(
                        color: Colors.white
                            .withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              const Text(
                                'Drug Management',
                                style: TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 34,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                'Manage all medicine database',
                                style: TextStyle(
                                  color: Colors.white
                                      .withOpacity(
                                          0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 90,
                          height: 90,
                          decoration:
                              BoxDecoration(
                            shape: BoxShape.circle,
                            gradient:
                                LinearGradient(
                              colors: [
                                Colors.cyanAccent
                                    .withOpacity(
                                        0.3),
                                Colors.blueAccent
                                    .withOpacity(
                                        0.2),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons
                                .medication_rounded,
                            color: Colors.white24,
                            size: 50,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // SEARCH
                  // =====================================================

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
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
                                      0.5),
                            ),

                            prefixIcon:
                                const Icon(
                              Icons.search,
                              color:
                                  Colors.cyanAccent,
                            ),

                            filled: true,

                            fillColor: Colors
                                .white
                                .withOpacity(
                                    0.05),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                              borderSide:
                                  BorderSide(
                                color: Colors
                                    .white
                                    .withOpacity(
                                        0.08),
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
                              borderSide:
                                  const BorderSide(
                                color:
                                    Colors.cyanAccent,
                              ),
                            ),
                          ),
                          onChanged: (v) {
                            applyFilter();
                          },
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        flex: 2,
                        child:
                            DropdownButtonFormField<
                                String>(
                          value:
                              selectedFilter,
                          dropdownColor:
                              const Color(
                                  0xff10192d),
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                          ),
                          decoration:
                              InputDecoration(
                            filled: true,
                            fillColor: Colors
                                .white
                                .withOpacity(
                                    0.05),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          18),
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
                    ],
                  ),

                  const SizedBox(height: 26),

                  // =====================================================
                  // EMPTY
                  // =====================================================

                  if (filteredDrugs.isEmpty)
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                              40),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                                24),
                        color: Colors.white
                            .withOpacity(0.04),
                      ),
                      child: const Center(
                        child: Text(
                          'No drugs found',
                          style: TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

                  // =====================================================
                  // GRID
                  // =====================================================

                  if (filteredDrugs.isNotEmpty)
                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          filteredDrugs.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            isMobile ? 1 : 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio:
                            isMobile
                                ? 1.55
                                : 1.7,
                      ),
                      itemBuilder:
                          (context, index) {

                        final drug =
                            filteredDrugs[index];

                        final bool
                            isPediatric =
                            drug['drug_type']
                                    ?.toString()
                                    .toLowerCase()
                                    .contains(
                                        'pediatric') ??
                                false;

                        return Container(
                          padding:
                              const EdgeInsets.all(
                                  22),
                          decoration:
                              BoxDecoration(
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        28),
                            color: Colors.white
                                .withOpacity(
                                    0.05),
                            border: Border.all(
                              color: Colors
                                  .white
                                  .withOpacity(
                                      0.08),
                            ),
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [

                              // TOP

                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(12),
                                    decoration:
                                        BoxDecoration(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  18),
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
                                      color: Colors
                                          .white,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          12,
                                      vertical: 7,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                                  50),
                                      color: isPediatric
                                          ? Colors
                                              .orange
                                              .withOpacity(
                                                  0.2)
                                          : Colors
                                              .green
                                              .withOpacity(
                                                  0.2),
                                    ),
                                    child: Text(
                                      isPediatric
                                          ? 'Pediatric'
                                          : 'General',
                                      style:
                                          TextStyle(
                                        color: isPediatric
                                            ? Colors
                                                .orangeAccent
                                            : Colors
                                                .greenAccent,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        fontSize:
                                            11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                  height: 18),

                              // NAME

                              Text(
                                drug['name']
                                    .toString(),
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontSize: 22,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              // GENERIC

                              Text(
                                drug['generic_name']
                                        ?.toString() ??
                                    '-',
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style: TextStyle(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                          0.7),
                                ),
                              ),

                              const SizedBox(
                                  height: 18),

                              // CHIP

                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  buildChip(
                                    Icons.category,
                                    drug['category']
                                            ?.toString() ??
                                        '-',
                                  ),

                                  buildChip(
                                    Icons.science,
                                    drug['dose']
                                            ?.toString() ??
                                        '-',
                                  ),

                                  buildChip(
                                    Icons.medication,
                                    drug['dosage_form']
                                            ?.toString() ??
                                        '-',
                                  ),
                                ],
                              ),

                              const Spacer(),

                              // BUTTON

                              Row(
                                children: [
                                  Expanded(
                                    child:
                                        ElevatedButton.icon(
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        backgroundColor:
                                            Colors
                                                .orange,
                                        foregroundColor:
                                            Colors
                                                .white,
                                      ),
                                      onPressed:
                                          () async {

                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    EditDrugPage(
                                              drug:
                                                  drug,
                                            ),
                                          ),
                                        );

                                        loadDrugs();
                                      },
                                      icon:
                                          const Icon(
                                        Icons.edit,
                                      ),
                                      label:
                                          const Text(
                                        'Edit',
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      width: 12),

                                  Expanded(
                                    child:
                                        ElevatedButton.icon(
                                      style:
                                          ElevatedButton
                                              .styleFrom(
                                        backgroundColor:
                                            Colors
                                                .red,
                                        foregroundColor:
                                            Colors
                                                .white,
                                      ),
                                      onPressed:
                                          () {
                                        deleteDrug(
                                          drug[
                                              'id'],
                                        );
                                      },
                                      icon:
                                          const Icon(
                                        Icons
                                            .delete,
                                      ),
                                      label:
                                          const Text(
                                        'Delete',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}