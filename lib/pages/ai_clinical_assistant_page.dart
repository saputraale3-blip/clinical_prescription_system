import 'package:flutter/material.dart';

import '../services/ai_prescription_service.dart';
import '../services/supabase_service.dart';

class AIClinicalAssistantPage
    extends StatefulWidget {

  const AIClinicalAssistantPage({
    super.key,
  });

  @override
  State<AIClinicalAssistantPage>
      createState() =>
          _AIClinicalAssistantPageState();
}

class _AIClinicalAssistantPageState
    extends State<
        AIClinicalAssistantPage> {

  final TextEditingController
      symptomController =
      TextEditingController();

  final TextEditingController
      weightController =
      TextEditingController();

  bool isLoading = true;

  bool hasAccess = false;

  String userRole = 'basic';

  List<Map<String, dynamic>>
      generatedPrescription = [];

  List<Map<String, dynamic>>
      drugDatabase = [];

  List<Map<String, dynamic>>
      pediatricDatabase = [];

  // =====================================================
  // INIT
  // =====================================================

  @override
  void initState() {

    super.initState();

    initializePage();
  }

  // =====================================================
  // INITIALIZE
  // =====================================================

  Future<void> initializePage() async {

    try {

      final currentUser =
          await SupabaseService
              .getCurrentUserData();

      userRole =
          (currentUser?['role'] ?? 'user')
              .toString()
              .toLowerCase();

      userRole =
          (currentUser?['role'] ?? 'basic')
              .toString()
              .toLowerCase();

      // HANYA PRO DAN ADMIN
      hasAccess =
          userRole == 'pro' ||
          userRole == 'admin';

      if (hasAccess) {

        final drugs =
            await SupabaseService
                .getDrugs();

        final pediatric =
            await SupabaseService
                .getPediatricDrugs();

        drugDatabase = drugs;

        pediatricDatabase =
            pediatric;
      }

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
  // GENERATE AI
  // =====================================================

  void generateAI() {

    final weight =
        double.tryParse(
              weightController.text,
            ) ??
            0;

    final result =
        AIPrescriptionService
            .generatePrescription(

      symptom:
          symptomController.text,

      weightKg: weight,

      pediatricDatabase:
          pediatricDatabase,

      drugDatabase:
          drugDatabase,
    );

    setState(() {

      generatedPrescription =
          result;
    });
  }

  // =====================================================
  // BUILD PRESCRIPTION
  // =====================================================

  String buildPrescription() {

    String result = '';

    for (var drug
        in generatedPrescription) {

      result +=
          'R/ ${drug['name']} ${drug['dose']}\n';

      result +=
          'S: ${drug['signa']}\n';

      result +=
          '${drug['instruction']}\n\n';
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
        color:
            Colors.white54,
      ),

      filled: true,

      fillColor:
          const Color(
        0xff111827,
      ),

      enabledBorder:
          OutlineInputBorder(

        borderRadius:
            BorderRadius.circular(
          20,
        ),

        borderSide:
            BorderSide(

          color: Colors.white
              .withOpacity(
            0.1,
          ),
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

    if (isLoading) {

      return const Scaffold(

        backgroundColor:
            Color(0xff020617),

        body: Center(

          child:
              CircularProgressIndicator(
            color:
                Colors.cyanAccent,
          ),
        ),
      );
    }

    // =====================================================
    // BLOCK BASIC USER
    // =====================================================

    if (!hasAccess) {

      return Scaffold(

        backgroundColor:
            const Color(0xff020617),

        body: Center(

          child: Container(

            width: 500,

            padding:
                const EdgeInsets.all(
              32,
            ),

            decoration:
                BoxDecoration(

              borderRadius:
                  BorderRadius.circular(
                28,
              ),

              color:
                  Colors.white
                      .withOpacity(
                0.04,
              ),

              border:
                  Border.all(

                color:
                    Colors.redAccent
                        .withOpacity(
                  0.3,
                ),
              ),
            ),

            child: Column(

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                const Icon(

                  Icons.lock_rounded,

                  color:
                      Colors.redAccent,

                  size: 90,
                ),

                const SizedBox(
                  height: 24,
                ),

                const Text(

                  'PRO FEATURE',

                  style: TextStyle(

                    color:
                        Colors.redAccent,

                    fontSize: 28,

                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Text(

                  'AI Clinical Assistant hanya tersedia untuk akun PRO dan ADMIN.',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(

                    color: Colors.white
                        .withOpacity(
                      0.7,
                    ),

                    fontSize: 18,

                    height: 1.6,
                  ),
                ),

                const SizedBox(
                  height: 26,
                ),

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),

                  decoration:
                      BoxDecoration(

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),

                    color:
                        Colors.cyanAccent
                            .withOpacity(
                      0.1,
                    ),
                  ),

                  child: const Text(

                    'Upgrade to PRO to unlock AI Prescription Generator',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(

                      color:
                          Colors.cyanAccent,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // =====================================================
    // NORMAL PAGE
    // =====================================================

    return Scaffold(

      backgroundColor:
          const Color(
        0xff020617,
      ),

      body: SafeArea(

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

              const Text(

                'AI Clinical Assistant',

                style: TextStyle(

                  color:
                      Colors.white,

                  fontSize: 36,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Text(

                'Smart AI Prescription Generator',

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

              // =====================================================
              // AI CARD
              // =====================================================

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

                  color:
                      Colors.cyanAccent
                          .withOpacity(
                    0.05,
                  ),

                  border:
                      Border.all(

                    color:
                        Colors.cyanAccent
                            .withOpacity(
                      0.2,
                    ),
                  ),
                ),

                child: Column(

                  children: [

                    TextField(

                      controller:
                          symptomController,

                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          cyberInput(
                        'Example: Demam anak 12kg',
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextField(

                      controller:
                          weightController,

                      keyboardType:
                          TextInputType.number,

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
                      height: 24,
                    ),

                    SizedBox(

                      width:
                          double.infinity,

                      height: 58,

                      child:
                          ElevatedButton.icon(

                        onPressed:
                            generateAI,

                        style:
                            ElevatedButton.styleFrom(

                          backgroundColor:
                              Colors.cyanAccent,

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
                          Icons.auto_awesome,
                        ),

                        label:
                            const Text(

                          'Generate AI Prescription',

                          style: TextStyle(

                            fontSize: 18,

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

              // =====================================================
              // RESULT
              // =====================================================

              if (generatedPrescription
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

                    color:
                        Colors.white
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

                    buildPrescription(),

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