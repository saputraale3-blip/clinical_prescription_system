import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase =
      Supabase.instance.client;

  // =====================================================
  // GET ALL DRUGS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getDrugs() async {
    final response =
        await supabase
            .from('drugs')
            .select()
            .order('name');

    return List<Map<String, dynamic>>
        .from(response);
  }

  // =====================================================
  // GET PEDIATRIC DRUGS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getPediatricDrugs() async {
    final response =
        await supabase
            .from('drugs')
            .select()
            .eq(
              'drug_type',
              'pediatric',
            )
            .order('name');

    return List<Map<String, dynamic>>
        .from(response);
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
    await supabase
        .from('drugs')
        .insert({
      'name': name,
      'generic_name':
          genericName,
      'category':
          category,
      'dosage_form':
          dosageForm,
      'dose':
          dose,
      'frequency':
          frequency,

      'frequency_signa':
          frequencySigna,

      'signa_unit':
          signaUnit,

      'signa_note':
          signaNote,

      'qty_default':
          qtyDefault,

      'prescription_template':
          prescription,

      'note':
          note,

      'drug_type':
          drugType,

      'mg_per_kg_min':
          mgPerKgMin,

      'mg_per_kg_max':
          mgPerKgMax,

      'syrup_mg':
          syrupMg,

      'syrup_ml':
          syrupMl,
    });
  }

  // =====================================================
  // UPDATE DRUG
  // =====================================================

  static Future<void> updateDrug({
    required int id,
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
    await supabase
        .from('drugs')
        .update({
      'name': name,
      'generic_name':
          genericName,
      'category':
          category,
      'dosage_form':
          dosageForm,
      'dose':
          dose,
      'frequency':
          frequency,

      'frequency_signa':
          frequencySigna,

      'signa_unit':
          signaUnit,

      'signa_note':
          signaNote,

      'qty_default':
          qtyDefault,

      'prescription_template':
          prescription,

      'note':
          note,

      'drug_type':
          drugType,

      'mg_per_kg_min':
          mgPerKgMin,

      'mg_per_kg_max':
          mgPerKgMax,

      'syrup_mg':
          syrupMg,

      'syrup_ml':
          syrupMl,
    }).eq('id', id);
  }

  // =====================================================
  // DELETE DRUG
  // =====================================================

  static Future<void>
      deleteDrug(int id) async {
    await supabase
        .from('drugs')
        .delete()
        .eq('id', id);
  }

  // =====================================================
  // GET USERS
  // =====================================================

  static Future<List<Map<String, dynamic>>>
      getUsers() async {
    final response =
        await supabase
            .from('profiles')
            .select()
            .order('created_at');

    return List<Map<String, dynamic>>
        .from(response);
  }

  // =====================================================
  // UPDATE USER ROLE
  // =====================================================

  static Future<void>
      updateUserRole({
    required String userId,
    required bool isAdmin,
  }) async {
    await supabase
        .from('profiles')
        .update({
      'role':
          isAdmin
              ? 'admin'
              : 'user',
    }).eq('id', userId);
  }

  // =====================================================
  // APPROVE USER
  // =====================================================

  static Future<void>
      approveUser({
    required String userId,
    required bool approved,
  }) async {
    await supabase
        .from('profiles')
        .update({
      'approved':
          approved,
    }).eq('id', userId);
  }

  // =====================================================
  // DELETE USER
  // =====================================================

  static Future<void>
      deleteUser({
    required String userId,
  }) async {
    await supabase
        .from('profiles')
        .delete()
        .eq('id', userId);
  }
}