import 'dart:ui';

import 'package:flutter/material.dart';

class UpgradePage extends StatelessWidget {

  const UpgradePage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff020617),

      body: Stack(

        children: [

          Positioned(
            top: -120,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.cyanAccent.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.purpleAccent.withOpacity(0.08),
              ),
            ),
          ),

          SafeArea(

            child: SingleChildScrollView(

              padding:
                  const EdgeInsets.all(24),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const SizedBox(height: 10),

                  const Text(

                    'Upgrade Membership',

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 34,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    'Unlock premium clinical AI features',

                    style: TextStyle(

                      color:
                          Colors.white.withOpacity(0.6),

                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // =====================================================
// BASIC CARD
// =====================================================

ClipRRect(

  borderRadius:
      BorderRadius.circular(32),

  child: BackdropFilter(

    filter:
        ImageFilter.blur(

      sigmaX: 14,

      sigmaY: 14,
    ),

    child: Container(

      width: double.infinity,

      padding:
          const EdgeInsets.all(32),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(32),

        color:
            Colors.white.withOpacity(0.05),

        border: Border.all(

          color:
              Colors.orangeAccent
                  .withOpacity(0.4),

          width: 1.5,
        ),
      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Container(

                padding:
                    const EdgeInsets.all(14),

                decoration:
                    BoxDecoration(

                  shape: BoxShape.circle,

                  color:
                      Colors.orangeAccent
                          .withOpacity(0.15),
                ),

                child: const Icon(

                  Icons.star,

                  color:
                      Colors.orangeAccent,

                  size: 34,
                ),
              ),

              const SizedBox(width: 18),

              const Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    'BASIC PLAN',

                    style: TextStyle(

                      color:
                          Colors.orangeAccent,

                      fontSize: 16,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(

                    'Rp 39.000 / month',

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 34),

          buildFeature(
            'Access Drug Database',
          ),

          buildFeature(
            'Prescription Generator',
          ),

          buildFeature(
            'Pediatric Dose Calculator',
          ),

          buildFeature(
            'Regular System Updates',
          ),

          const SizedBox(height: 36),

          SizedBox(

            width: double.infinity,

            height: 60,

            child: ElevatedButton.icon(

              onPressed: () {

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(

                  const SnackBar(

                    content: Text(
                      'Payment gateway coming soon',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    Colors.orangeAccent,

                foregroundColor:
                    Colors.black,

                shape:
                    RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(22),
                ),
              ),

              icon: const Icon(
                Icons.lock_open,
              ),

              label: const Text(

                'Upgrade to BASIC',

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
  ),
),

const SizedBox(height: 30),

                  // =====================================================
                  // PRO CARD
                  // =====================================================

                  ClipRRect(

                    borderRadius:
                        BorderRadius.circular(32),

                    child: BackdropFilter(

                      filter:
                          ImageFilter.blur(

                        sigmaX: 14,

                        sigmaY: 14,
                      ),

                      child: Container(

                        width: double.infinity,

                        padding:
                            const EdgeInsets.all(32),

                        decoration:
                            BoxDecoration(

                          borderRadius:
                              BorderRadius.circular(32),

                          color:
                              Colors.white.withOpacity(0.05),

                          border: Border.all(

                            color:
                                Colors.cyanAccent
                                    .withOpacity(0.4),

                            width: 1.5,
                          ),
                        ),

                        child: Column(

                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Row(

                              children: [

                                Container(

                                  padding:
                                      const EdgeInsets.all(14),

                                  decoration:
                                      BoxDecoration(

                                    shape: BoxShape.circle,

                                    color:
                                        Colors.cyanAccent
                                            .withOpacity(0.15),
                                  ),

                                  child: const Icon(

                                    Icons.workspace_premium,

                                    color:
                                        Colors.cyanAccent,

                                    size: 34,
                                  ),
                                ),

                                const SizedBox(width: 18),

                                const Column(

                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    Text(

                                      'PRO PLAN',

                                      style: TextStyle(

                                        color:
                                            Colors.cyanAccent,

                                        fontSize: 16,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),

                                    SizedBox(height: 6),

                                    Text(

                                      'Rp 99.000 / month',

                                      style: TextStyle(

                                        color:
                                            Colors.white,

                                        fontSize: 28,

                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 34),

                            buildFeature(
                              'Unlimited AI Clinical Chat',
                            ),

                            buildFeature(
                              'AI Prescription Generator',
                            ),

                            buildFeature(
                              'Advanced Pediatric Calculator',
                            ),

                            buildFeature(
                              'Priority Updates',
                            ),

                            buildFeature(
                              'Premium Drug Database',
                            ),

                            buildFeature(
                              'Clinical Decision Support',
                            ),

                            const SizedBox(height: 36),

                            SizedBox(

                              width: double.infinity,

                              height: 60,

                              child: ElevatedButton.icon(

                                onPressed: () {

                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(

                                    const SnackBar(

                                      content: Text(
                                        'Payment gateway coming soon',
                                      ),
                                    ),
                                  );
                                },

                                style:
                                    ElevatedButton.styleFrom(

                                  backgroundColor:
                                      Colors.cyanAccent,

                                  foregroundColor:
                                      Colors.black,

                                  shape:
                                      RoundedRectangleBorder(

                                    borderRadius:
                                        BorderRadius.circular(22),
                                  ),
                                ),

                                icon: const Icon(
                                  Icons.lock_open,
                                ),

                                label: const Text(

                                  'Upgrade to PRO',

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
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(

                    'Secure payment via QRIS, E-Wallet, Bank Transfer, and Credit Card.',

                    style: TextStyle(

                      color:
                          Colors.white.withOpacity(0.45),

                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFeature(String text) {

    return Padding(

      padding:
          const EdgeInsets.only(bottom: 18),

      child: Row(

        children: [

          const Icon(

            Icons.check_circle,

            color: Colors.greenAccent,
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Text(

              text,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}