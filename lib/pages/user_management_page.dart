import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class UserManagementPage
    extends StatefulWidget {

  const UserManagementPage({
    super.key,
  });

  @override
  State<UserManagementPage>
      createState() =>
          _UserManagementPageState();
}

class _UserManagementPageState
    extends State<
        UserManagementPage> {

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

  // =========================
  // LOAD USERS
  // =========================

  Future<void> loadUsers() async {

    try {

      final data =
          await SupabaseService
              .getUsers();

      setState(() {

        users = data;

        filteredUsers =
            List.from(data);

        isLoading = false;
      });
    }

    catch (e) {

      setState(() {

        isLoading = false;
      });

      debugPrint(
        e.toString(),
      );
    }
  }

  // =========================
  // SEARCH USER
  // =========================

  void searchUser(
    String query,
  ) {

    final result =
        users.where((user) {

      final username =
          (user['username'] ?? '')
              .toString()
              .toLowerCase();

      return username.contains(
        query.toLowerCase(),
      );

    }).toList();

    setState(() {

      filteredUsers = result;
    });
  }

  // =========================
  // CHANGE ROLE
  // =========================

  Future<void> changeRole({

    required String userId,

    required bool isAdmin,

  }) async {

    try {

      await SupabaseService
          .updateUserRole(

        userId: userId,

        isAdmin: isAdmin,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(

            isAdmin

                ? 'User changed to ADMIN'

                : 'User changed to USER',
          ),
        ),
      );

      loadUsers();
    }

    catch (e) {

      if (!mounted) return;

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
  // APPROVE USER
  // =========================

  Future<void> approveUser({

    required String userId,

    required bool approved,

  }) async {

    try {

      await SupabaseService
          .approveUser(

        userId: userId,

        approved: approved,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content: Text(

            approved

                ? 'User Approved'

                : 'User Unapproved',
          ),
        ),
      );

      loadUsers();
    }

    catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content:
              Text(e.toString()),
        ),
      );
    }
  }

  // =========================
  // DELETE USER
  // =========================

  Future<void> deleteUser({

    required String userId,

  }) async {

    try {

      await SupabaseService
          .deleteUser(

        userId: userId,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        const SnackBar(

          content:
              Text('User deleted'),
        ),
      );

      loadUsers();
    }

    catch (e) {

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(

        SnackBar(

          content:
              Text(e.toString()),
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

        title:
            const Text(
          'User Management',
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
                              'Search username...',

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

                        onChanged:
                            searchUser,
                      ),
                    ),

                    // =========================
                    // USER LIST
                    // =========================

                    Expanded(

                      child:
                          filteredUsers
                                  .isEmpty

                              ? const Center(

                                  child: Text(

                                    'No users found',

                                    style:
                                        TextStyle(

                                      color:
                                          Colors.white70,

                                      fontSize:
                                          16,
                                    ),
                                  ),
                                )

                              : ListView.builder(

                                  itemCount:
                                      filteredUsers
                                          .length,

                                  itemBuilder:
                                      (context,
                                          index) {

                                    final user =
                                        filteredUsers[
                                            index];

                                    final bool
                                        isAdmin =
                                        user['is_admin'] ??
                                            false;

                                    final bool
                                        approved =
                                        user['approved'] ??
                                            false;

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
                                          Padding(

                                        padding:
                                            const EdgeInsets.all(
                                          10,
                                        ),

                                        child:
                                            Column(

                                          children: [

                                            ListTile(

                                              leading:
                                                  CircleAvatar(

                                                backgroundColor:

                                                    isAdmin

                                                        ? Colors
                                                            .cyanAccent

                                                        : Colors
                                                            .grey,

                                                child: Icon(

                                                  isAdmin

                                                      ? Icons.admin_panel_settings

                                                      : Icons.person,

                                                  color:
                                                      Colors.black,
                                                ),
                                              ),

                                              title:
                                                  Text(

                                                user['username'] ??
                                                    '-',

                                                style:
                                                    const TextStyle(

                                                  color:
                                                      Colors.white,

                                                  fontWeight:
                                                      FontWeight.bold,

                                                  fontSize:
                                                      16,
                                                ),
                                              ),

                                              subtitle:
                                                  Column(

                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,

                                                children: [

                                                  const SizedBox(
                                                      height: 5),

                                                  Text(

                                                    isAdmin

                                                        ? 'ADMIN'

                                                        : 'USER',

                                                    style:
                                                        TextStyle(

                                                      color:

                                                          isAdmin

                                                              ? Colors
                                                                  .cyanAccent

                                                              : Colors
                                                                  .white70,

                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),

                                                  const SizedBox(
                                                      height: 5),

                                                  Text(

                                                    approved

                                                        ? 'APPROVED'

                                                        : 'PENDING',

                                                    style:
                                                        TextStyle(

                                                      color:

                                                          approved

                                                              ? Colors
                                                                  .greenAccent

                                                              : Colors
                                                                  .orangeAccent,

                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const Divider(
                                              color:
                                                  Colors.white24,
                                            ),

                                            Row(

                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,

                                              children: [

                                                // ADMIN SWITCH

                                                Row(

                                                  children: [

                                                    const Text(

                                                      'Admin',

                                                      style:
                                                          TextStyle(
                                                        color:
                                                            Colors.white,
                                                      ),
                                                    ),

                                                    Switch(

                                                      value:
                                                          isAdmin,

                                                      activeColor:
                                                          Colors.cyanAccent,

                                                      onChanged:
                                                          (value) {

                                                        changeRole(

                                                          userId:
                                                              filteredUsers[index]['id'],

                                                          isAdmin:
                                                              value,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),

                                                // APPROVE SWITCH

                                                Row(

                                                  children: [

                                                    const Text(

                                                      'Approve',

                                                      style:
                                                          TextStyle(
                                                        color:
                                                            Colors.white,
                                                      ),
                                                    ),

                                                    Switch(

                                                      value:
                                                          approved,

                                                      activeColor:
                                                          Colors.greenAccent,

                                                      onChanged:
                                                          (value) {

                                                        approveUser(

                                                          userId:
                                                              filteredUsers[index]['id'],

                                                          approved:
                                                              value,
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),

                                                // DELETE

                                                IconButton(

                                                  onPressed: () {

                                                    deleteUser(

                                                      userId:
                                                          filteredUsers[index]['id'],
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