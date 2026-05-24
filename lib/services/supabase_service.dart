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
              .select('*')
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

    required bool isAdmin,

  }) async {

    try {

      await supabase
          .from('profiles')
          .update({

        'is_admin': isAdmin,

        'role':
            isAdmin
                ? 'admin'
                : 'user',

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

      await supabase
          .from('profiles')
          .update({

        'approved': approved,

      }).eq('id', userId);

    } catch (e) {

      debugPrint(
        'APPROVE USER ERROR: $e',
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
}