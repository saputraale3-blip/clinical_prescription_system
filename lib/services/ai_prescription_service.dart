class AIPrescriptionService {

  // =====================================================
  // AI ENGINE
  // =====================================================

  static List<Map<String, dynamic>>
      generatePrescription({

    required String symptom,

    required double weightKg,

    required List<Map<String, dynamic>>
        pediatricDatabase,

    required List<Map<String, dynamic>>
        drugDatabase,
  }) {

    final text =
        symptom.toLowerCase();

    List<Map<String, dynamic>>
        results = [];

    // =====================================================
    // FEVER
    // =====================================================

    if (text.contains('demam') ||
        text.contains('fever')) {

      final paracetamol =
          pediatricDatabase.firstWhere(

        (drug) =>
            drug['name']
                .toString()
                .toLowerCase()
                .contains('paracetamol'),

        orElse: () => {},
      );

      if (paracetamol.isNotEmpty) {

        final doseMg =
            weightKg * 15;

        final syrupMg =
            (paracetamol['syrup_mg'] ?? 120)
                .toDouble();

        final syrupMl =
            (paracetamol['syrup_ml'] ?? 5)
                .toDouble();

        final volumeMl =
            (doseMg / syrupMg) *
                syrupMl;

        results.add({

          'name':
              paracetamol['name'],

          'dose':
              '${doseMg.toStringAsFixed(0)} mg',

          'form': 'Syrup',

          'qty': '1',

          'signa':
              '3 dd ${volumeMl.toStringAsFixed(1)} mL p.c',

          'instruction':
              'For fever and pain',
        });
      }
    }

    // =====================================================
    // TOOTHACHE
    // =====================================================

    if (text.contains('nyeri') ||
        text.contains('toothache') ||
        text.contains('sakit gigi')) {

      final mefenamic =
          drugDatabase.firstWhere(

        (drug) =>
            drug['name']
                .toString()
                .toLowerCase()
                .contains('mefen'),

        orElse: () => {},
      );

      if (mefenamic.isNotEmpty) {

        results.add({

          'name':
              mefenamic['name'],

          'dose':
              mefenamic['strength'] ??
                  mefenamic['dose'],

          'form':
              mefenamic['dosage_form'],

          'qty': '10',

          'signa':
              '3 dd tab I p.c',

          'instruction':
              'Take after meals',
        });
      }
    }

    // =====================================================
    // INFECTION
    // =====================================================

    if (text.contains('infeksi') ||
        text.contains('infection')) {

      final amoxicillin =
          drugDatabase.firstWhere(

        (drug) =>
            drug['name']
                .toString()
                .toLowerCase()
                .contains('amoxicillin'),

        orElse: () => {},
      );

      if (amoxicillin.isNotEmpty) {

        results.add({

          'name':
              amoxicillin['name'],

          'dose':
              amoxicillin['strength'] ??
                  amoxicillin['dose'],

          'form':
              amoxicillin['dosage_form'],

          'qty': '15',

          'signa':
              '3 dd cap I p.c',

          'instruction':
              'Antibiotic',
        });
      }
    }

    return results;
  }
}