import 'dart:ui';

import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class UserManagementPage extends StatefulWidget {

  const UserManagementPage({
    super.key,
  });

  @override
  State<UserManagementPage>
      createState() =>
          _UserManagementPageState();
}

class _UserManagementPageState
    extends State<UserManagementPage> {

  final TextEditingController
      searchController =
      TextEditingController();

  List<Map<String, dynamic>>
      users = [];

  List<Map<String, dynamic>>
      filteredUsers = [];

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadUsers();
  }

  // =====================================================
  // LOAD USERS
  // =====================================================

  Future<void> loadUsers() async {

    try {

      final data =
          await SupabaseService
              .getUsers();

      setState(() {

        users =
            List<Map<String, dynamic>>
                .from(data);

        filteredUsers =
            List<Map<String, dynamic>>
                .from(data);

        isLoading = false;
      });

    } catch (e) {

      setState(() {

        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

  // =====================================================
  // SEARCH
  // =====================================================

  void searchUser(
    String query,
  ) {

    final result =
        users.where((user) {

      final username =
          (user['username'] ?? '')
              .toString()
              .toLowerCase();

      final role =
          (user['role'] ?? '')
              .toString()
              .toLowerCase();

      return username.contains(
                query.toLowerCase(),
              ) ||
          role.contains(
            query.toLowerCase(),
          );

    }).toList();

    setState(() {

      filteredUsers = result;
    });
  }

  // =====================================================
  // CHANGE ROLE
  // =====================================================

  Future<void> changeRole({

    required String userId,

    required bool isAdmin,

  }) async {

    await SupabaseService
        .updateUserRole(

      userId: userId,

      isAdmin: isAdmin,
    );

    loadUsers();
  }

  // =====================================================
  // APPROVE USER
  // =====================================================

  Future<void> approveUser({

    required String userId,

    required bool approved,

  }) async {

    await SupabaseService
        .approveUser(

      userId: userId,

      approved: approved,
    );

    loadUsers();
  }

  // =====================================================
  // DELETE USER
  // =====================================================

  Future<void> deleteUser({

    required String userId,

  }) async {

    final confirm =
        await showDialog<bool>(

      context: context,

      builder: (context) {

        return AlertDialog(

          backgroundColor:
              const Color(
            0xff121b2f,
          ),

          shape:
              RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),

          title: const Text(

            'Delete User',

            style: TextStyle(
              color: Colors.white,
            ),
          ),

          content: const Text(

            'Are you sure you want to delete this user?',

            style: TextStyle(
              color: Colors.white70,
            ),
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

              style:
                  ElevatedButton.styleFrom(

                backgroundColor:
                    Colors.red,
              ),

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

    await SupabaseService
        .deleteUser(
      userId: userId,
    );

    loadUsers();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    final approvedCount =
        users
            .where(
              (e) =>
                  e['approved'] ==
                  true,
            )
            .length;

    final pendingCount =
        users
            .where(
              (e) =>
                  e['approved'] !=
                  true,
            )
            .length;

    final adminCount =
        users
            .where(
              (e) =>
                  e['is_admin'] ==
                  true,
            )
            .length;

    return Scaffold(

      backgroundColor:
          const Color(
        0xff07111f,
      ),

      body:

          isLoading

              ? const Center(

                  child:
                      CircularProgressIndicator(
                    color:
                        Colors.cyanAccent,
                  ),
                )

              : Stack(

                  children: [

                    Positioned(

                      top: -120,

                      right: -80,

                      child: Container(

                        width: 300,

                        height: 300,

                        decoration:
                            BoxDecoration(

                          shape:
                              BoxShape.circle,

                          color: Colors
                              .cyanAccent
                              .withOpacity(
                            0.08,
                          ),
                        ),
                      ),
                    ),

                    Positioned(

                      bottom: -100,

                      left: -60,

                      child: Container(

                        width: 250,

                        height: 250,

                        decoration:
                            BoxDecoration(

                          shape:
                              BoxShape.circle,

                          color: Colors
                              .purpleAccent
                              .withOpacity(
                            0.08,
                          ),
                        ),
                      ),
                    ),

                    SafeArea(

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

                              'User Management',

                              style:
                                  TextStyle(

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

                              'Manage user access, roles, and approval status',

                              style:
                                  TextStyle(

                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.6,
                                ),

                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            // =================================================
                            // STATS
                            // =================================================

                            Row(

                              children: [

                                Expanded(

                                  child:
                                      buildStatCard(

                                    title:
                                        'Total Users',

                                    value:
                                        users.length
                                            .toString(),

                                    icon:
                                        Icons.people_alt_rounded,

                                    color:
                                        Colors.cyanAccent,
                                  ),
                                ),

                                const SizedBox(
                                  width: 18,
                                ),

                                Expanded(

                                  child:
                                      buildStatCard(

                                    title:
                                        'Admins',

                                    value:
                                        adminCount
                                            .toString(),

                                    icon:
                                        Icons.admin_panel_settings_rounded,

                                    color:
                                        Colors.orangeAccent,
                                  ),
                                ),

                                const SizedBox(
                                  width: 18,
                                ),

                                Expanded(

                                  child:
                                      buildStatCard(

                                    title:
                                        'Approved',

                                    value:
                                        approvedCount
                                            .toString(),

                                    icon:
                                        Icons.verified_rounded,

                                    color:
                                        Colors.greenAccent,
                                  ),
                                ),

                                const SizedBox(
                                  width: 18,
                                ),

                                Expanded(

                                  child:
                                      buildStatCard(

                                    title:
                                        'Pending',

                                    value:
                                        pendingCount
                                            .toString(),

                                    icon:
                                        Icons.pending_actions_rounded,

                                    color:
                                        Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            // =================================================
                            // SEARCH
                            // =================================================

                            ClipRRect(

                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),

                              child:
                                  BackdropFilter(

                                filter:
                                    ImageFilter.blur(

                                  sigmaX: 14,

                                  sigmaY: 14,
                                ),

                                child:
                                    Container(

                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal:
                                        18,
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

                                  child:
                                      TextField(

                                    controller:
                                        searchController,

                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                    ),

                                    decoration:
                                        const InputDecoration(

                                      border:
                                          InputBorder.none,

                                      hintText:
                                          'Search username or role...',

                                      hintStyle:
                                          TextStyle(

                                        color:
                                            Colors.white54,
                                      ),

                                      icon:
                                          Icon(

                                        Icons.search_rounded,

                                        color:
                                            Colors.cyanAccent,
                                      ),
                                    ),

                                    onChanged:
                                        searchUser,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 28,
                            ),

                            // =================================================
                            // USER LIST
                            // =================================================

                            if (filteredUsers
                                .isEmpty)

                              Container(

                                width:
                                    double.infinity,

                                padding:
                                    const EdgeInsets.all(
                                  40,
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
                                    0.04,
                                  ),
                                ),

                                child: const Center(

                                  child: Text(

                                    'No users found',

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.white70,

                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )

                            else

                              Column(

                                children:
                                    filteredUsers.map(
                                  (
                                    user,
                                  ) {

                                    final bool
                                        isAdmin =
                                        user['is_admin'] ??
                                            false;

                                    final bool
                                        approved =
                                        user['approved'] ??
                                            false;

                                    return buildUserCard(

                                      user:
                                          user,

                                      isAdmin:
                                          isAdmin,

                                      approved:
                                          approved,
                                    );
                                  },
                                ).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  // =====================================================
  // USER CARD
  // =====================================================

  Widget buildUserCard({

    required Map<String, dynamic>
        user,

    required bool isAdmin,

    required bool approved,

  }) {

    return Container(

      margin:
          const EdgeInsets.only(
        bottom: 20,
      ),

      child: ClipRRect(

        borderRadius:
            BorderRadius.circular(
          28,
        ),

        child: BackdropFilter(

          filter:
              ImageFilter.blur(

            sigmaX: 14,

            sigmaY: 14,
          ),

          child: Container(

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

              children: [

                Row(

                  children: [

                    Container(

                      width: 70,

                      height: 70,

                      decoration:
                          BoxDecoration(

                        shape:
                            BoxShape.circle,

                        gradient:
                            LinearGradient(

                          colors:

                              isAdmin

                                  ? [

                                      Colors.orangeAccent,

                                      Colors.deepOrange,
                                    ]

                                  : [

                                      Colors.cyanAccent,

                                      Colors.blueAccent,
                                    ],
                        ),
                      ),

                      child: Icon(

                        isAdmin

                            ? Icons.admin_panel_settings_rounded

                            : Icons.person_rounded,

                        color:
                            Colors.white,

                        size: 34,
                      ),
                    ),

                    const SizedBox(
                      width: 18,
                    ),

                    Expanded(

                      child:
                          Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(

                            user['username'] ??
                                '-',

                            style:
                                const TextStyle(

                              color:
                                  Colors.white,

                              fontSize: 22,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height: 6,
                          ),

                          Text(

                            user['email'] ??
                                'No Email',

                            style:
                                TextStyle(

                              color: Colors
                                  .white
                                  .withOpacity(
                                0.6,
                              ),

                              fontSize:
                                  14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    buildBadge(

                      text:

                          approved

                              ? 'APPROVED'

                              : 'PENDING',

                      color:

                          approved

                              ? Colors.greenAccent

                              : Colors.orangeAccent,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                Row(

                  children: [

                    Expanded(

                      child:
                          buildActionCard(

                        title:
                            'Admin Access',

                        subtitle:

                            isAdmin

                                ? 'Administrator'

                                : 'Standard User',

                        switchValue:
                            isAdmin,

                        switchColor:
                            Colors.cyanAccent,

                        onChanged:
                            (value) {

                          changeRole(

                            userId:
                                user['id'],

                            isAdmin:
                                value,
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 18,
                    ),

                    Expanded(

                      child:
                          buildActionCard(

                        title:
                            'Approval',

                        subtitle:

                            approved

                                ? 'Approved'

                                : 'Pending',

                        switchValue:
                            approved,

                        switchColor:
                            Colors.greenAccent,

                        onChanged:
                            (value) {

                          approveUser(

                            userId:
                                user['id'],

                            approved:
                                value,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                SizedBox(

                  width:
                      double.infinity,

                  height: 54,

                  child:
                      ElevatedButton.icon(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          Colors.redAccent,

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    onPressed: () {

                      deleteUser(

                        userId:
                            user['id'],
                      );
                    },

                    icon:
                        const Icon(
                      Icons.delete_rounded,
                    ),

                    label:
                        const Text(

                      'Delete User',

                      style: TextStyle(

                        fontWeight:
                            FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // ACTION CARD
  // =====================================================

  Widget buildActionCard({

    required String title,

    required String subtitle,

    required bool switchValue,

    required Color switchColor,

    required Function(bool)
        onChanged,

  }) {

    return Container(

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

      child: Column(

        children: [

          Text(

            title,

            style:
                const TextStyle(

              color:
                  Colors.white,

              fontWeight:
                  FontWeight.bold,

              fontSize: 16,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Text(

            subtitle,

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
            height: 12,
          ),

          Switch(

            value:
                switchValue,

            activeColor:
                switchColor,

            onChanged:
                onChanged,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // BADGE
  // =====================================================

  Widget buildBadge({

    required String text,

    required Color color,

  }) {

    return Container(

      padding:
          const EdgeInsets.symmetric(

        horizontal: 16,

        vertical: 10,
      ),

      decoration:
          BoxDecoration(

        borderRadius:
            BorderRadius.circular(
          40,
        ),

        color:
            color.withOpacity(
          0.14,
        ),
      ),

      child: Text(

        text,

        style:
            TextStyle(

          color: color,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  // =====================================================
  // STATS CARD
  // =====================================================

  Widget buildStatCard({

    required String title,

    required String value,

    required IconData icon,

    required Color color,

  }) {

    return ClipRRect(

      borderRadius:
          BorderRadius.circular(
        24,
      ),

      child: BackdropFilter(

        filter:
            ImageFilter.blur(

          sigmaX: 14,

          sigmaY: 14,
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
              24,
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

              Container(

                width: 52,

                height: 52,

                decoration:
                    BoxDecoration(

                  shape:
                      BoxShape.circle,

                  color:
                      color.withOpacity(
                    0.15,
                  ),
                ),

                child: Icon(

                  icon,

                  color: color,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Text(

                value,

                style:
                    const TextStyle(

                  color:
                      Colors.white,

                  fontSize: 30,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(

                title,

                style:
                    TextStyle(

                  color: Colors
                      .white
                      .withOpacity(
                    0.65,
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