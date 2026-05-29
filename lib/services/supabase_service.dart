import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  static final supabase =
      Supabase.instance.client;

  // =====================================================
  // GET GENERAL DRUGS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getDrugs() async {

    try {

      final response =
          await supabase
              .from('drugs')
              .select();

      return List<Map<String, dynamic>>
          .from(response);

    } catch (e) {

      debugPrint(
        'GET DRUGS ERROR: $e',
      );

      return [];
    }
  }

  // =====================================================
  // GET PEDIATRIC DRUGS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getPediatricDrugs() async {

    try {

      final response =
          await supabase
              .from('pediatric_drugs')
              .select();

      return List<Map<String, dynamic>>
          .from(response);

    } catch (e) {

      debugPrint(
        'GET PEDIATRIC DRUGS ERROR: $e',
      );

      return [];
    }
  }

  // =====================================================
  // ADD DRUG
  // =====================================================

  static Future<void> addDrug({

    required String name,

    required String genericName,

    required String category,

    required String dosageForm,

    required String dose,

    required String frequency,

    String frequencySigna = '',

    String signaUnit = '',

    String signaNote = '',

    int qtyDefault = 10,

    required String prescription,

    required String note,

    required String drugType,

    double mgPerKgMin = 0,

    double mgPerKgMax = 0,

    double syrupMg = 0,

    double syrupMl = 0,

  }) async {

    try {

      // =================================================
      // PEDIATRIC
      // =================================================

      if (drugType == 'pediatric') {

        await supabase
            .from('pediatric_drugs')
            .insert({

          'name': name,

          'category': category,

          'dosage_form': dosageForm,

          'frequency': frequency,

          'mg_per_kg_min': mgPerKgMin,

          'mg_per_kg_max': mgPerKgMax,

          'syrup_mg': syrupMg,

          'syrup_ml': syrupMl,

          'note': note,
        });

        return;
      }

      // =================================================
      // GENERAL DRUG DATABASE
      // =================================================

      await supabase
          .from('drugs')
          .insert({

        'name': name,

        'generic_name': genericName,

        'category': category,

        'dosage_form': dosageForm,

        'dose': dose,

        'frequency': frequency,

        'frequency_signa': frequencySigna,

        'signa_unit': signaUnit,

        'signa_note': signaNote,

        'qty_default': qtyDefault,

        'prescription_template': prescription,

        'note': note,
      });

    } catch (e) {

      debugPrint(
        'ADD DRUG ERROR: $e',
      );
    }
  }

  // =====================================================
  // UPDATE DRUG
  // =====================================================

  static Future<void> updateDrug({

    required int id,

    required String table,

    required Map<String, dynamic> data,

  }) async {

    try {

      await supabase
          .from(table)
          .update(data)
          .eq('id', id);

    } catch (e) {

      debugPrint(
        'UPDATE DRUG ERROR: $e',
      );
    }
  }

  // =====================================================
  // DELETE DRUG
  // =====================================================

  static Future<void> deleteDrug({

    required int id,

    required String table,

  }) async {

    try {

      await supabase
          .from(table)
          .delete()
          .eq('id', id);

    } catch (e) {

      debugPrint(
        'DELETE DRUG ERROR: $e',
      );
    }
  }

  // =====================================================
  // GET USERS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getUsers() async {

    try {

      final response =
    await supabase
        .from('profiles')
        .select('''
          *,
          role,
          approved,
          trial_start,
          trial_end,
          is_admin
        ''')
        .order('username');

      final data =
          List<Map<String, dynamic>>.from(
        response,
      );

      debugPrint(
        'USERS DATA: $data',
      );

      return data;

    } catch (e) {

      debugPrint(
        'GET USERS ERROR: $e',
      );

      return [];
    }
  }

  // =====================================================
  // UPDATE USER ROLE
  // =====================================================

  static Future<void>
    updateUserRole({

  required String userId,

  required String role,

}) async {

  try {

    await supabase
        .from('profiles')
        .update({

      'role': role,

      'is_admin':
          role == 'admin',

    }).eq('id', userId);

  } catch (e) {

    debugPrint(
      'UPDATE USER ROLE ERROR: $e',
    );
  }
}

  // =====================================================
  // APPROVE USER
  // =====================================================

 static Future<void>
    approveUser({

  required String userId,

  required bool approved,

}) async {

  try {

    final now = DateTime.now();

    final end =
        now.add(
      const Duration(days: 3),
    );

    await supabase
        .from('profiles')
        .update({

      'approved': approved,

      'role': 'user',

      'trial_start':
          now.toIso8601String(),

      'trial_end':
          end.toIso8601String(),

    }).eq('id', userId);

  } catch (e) {

    debugPrint(
      'APPROVE USER ERROR: $e',
    );
  }
}

  // =====================================================
// UPDATE TRIAL
// =====================================================

static Future<void>
    updateTrial({

  required String userId,

  required DateTime startDate,

  required DateTime endDate,

}) async {

  try {

    await supabase
        .from('profiles')
        .update({

      'trial_start':
          startDate.toIso8601String(),

      'trial_end':
          endDate.toIso8601String(),

    }).eq('id', userId);

  } catch (e) {

    debugPrint(
      'UPDATE TRIAL ERROR: $e',
    );
  }
}

// =====================================================
// UPDATE USER ROLE ADVANCED
// =====================================================

static Future<void>
    updateUserRoleAdvanced({

  required String userId,

  required String role,

}) async {

  try {

    await supabase
        .from('profiles')
        .update({

      'role': role,

      'is_admin': role == 'admin',

    }).eq('id', userId);

  } catch (e) {

    debugPrint(
      'UPDATE ROLE ERROR: $e',
    );
  }
}

// =====================================================
// GIVE 30 DAYS TRIAL
// =====================================================

static Future<void>
    giveTrial30Days({

  required String userId,

}) async {

  try {

    final now = DateTime.now();

    final end =
        now.add(
      const Duration(days: 30),
    );

    await supabase
        .from('profiles')
        .update({

      'trial_start':
          now.toIso8601String(),

      'trial_end':
          end.toIso8601String(),

      'role': 'pro',

    }).eq('id', userId);

  } catch (e) {

    debugPrint(
      'TRIAL ERROR: $e',
    );
  }
}

    // =====================================================
  // DELETE USER
  // =====================================================

  static Future<void>
      deleteUser({

    required String userId,

  }) async {

    try {

      await supabase
          .from('profiles')
          .delete()
          .eq('id', userId);

    } catch (e) {

      debugPrint(
        'DELETE USER ERROR: $e',
      );
    }
  }

  // =====================================================
  // GET CURRENT USER DATA
  // =====================================================

  static Future<Map<String, dynamic>?>
      getCurrentUserData() async {

    try {

      final user =
          supabase.auth.currentUser;

      if (user == null) return null;

      final response =
          await supabase
              .from('profiles')
              .select()
              .eq('id', user.id)
              .single();

      return response;

    } catch (e) {

      debugPrint(
        'GET CURRENT USER ERROR: $e',
      );

      return null;
    }
  }
}