class LocalAIChatService {

  static String generateReply({

    required String message,

    required double weightKg,
  }) {

    final text =
        message.toLowerCase();

    // =====================================================
    // FEVER
    // =====================================================

    if (

        text.contains('demam') ||
        text.contains('panas') ||
        text.contains('menggigil')

    ) {

      // =====================================================
      // IF WEIGHT NOT FILLED
      // =====================================================

      if (weightKg <= 0) {

        return '''
Pasien tampaknya mengalami demam.

Mohon masukkan berat badan pasien agar AI dapat menghitung dosis dengan tepat.
''';
      }

      // =====================================================
      // PARACETAMOL CALCULATION
      // =====================================================

      // Standard pediatric dose
      // 15 mg/kg/dose

      final mgPerKg = 15.0;

      // Needed dose in mg
      final neededMg =
          mgPerKg * weightKg;

      // Syrup concentration
      // 120mg / 5mL

      final syrupMg = 120.0;

      final syrupMl = 5.0;

      // Calculate final mL

      final calculatedMl =

          (neededMg / syrupMg) *
              syrupMl;

      final dose =
          neededMg
              .toStringAsFixed(0);

      final finalMl =
          calculatedMl
              .toStringAsFixed(1);

      return '''

Kemungkinan pasien mengalami demam.

Perhitungan dosis:

15 mg × $weightKg kg
= $dose mg

R/

Paracetamol Syrup 120mg/5mL

S:

3 dd $finalMl mL p.c

Gunakan setelah makan.

Pantau suhu tubuh pasien dan hidrasi.
''';
    }

    // =====================================================
    // TOOTHACHE
    // =====================================================

    if (

        text.contains('sakit gigi') ||
        text.contains('gigi') ||
        text.contains('nyeri')

    ) {

      return '''

Kemungkinan terjadi nyeri odontogenik.

Rekomendasi:

R/

Paracetamol 500mg

S:

3 dd tab I p.c

Gunakan setelah makan.

Jika nyeri menetap pertimbangkan pemeriksaan klinis lebih lanjut.
''';
    }

    // =====================================================
    // SWELLING / INFECTION
    // =====================================================

    if (

        text.contains('bengkak') ||
        text.contains('nanah') ||
        text.contains('infeksi')

    ) {

      return '''

Kemungkinan terjadi infeksi odontogenik.

Rekomendasi:

R/

Amoxicillin 500mg

S:

3 dd caps I p.c

Gunakan selama 5 hari.

Pertimbangkan evaluasi sumber infeksi.
''';
    }

    // =====================================================
    // DEFAULT
    // =====================================================

    return '''
AI belum memahami kondisi tersebut.

Coba jelaskan gejala utama pasien secara lebih detail.
''';
  }
}