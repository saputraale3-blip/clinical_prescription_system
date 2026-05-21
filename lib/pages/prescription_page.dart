import 'package:flutter/material.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {

  final patientController = TextEditingController();

  final instructionController = TextEditingController();

  String selectedDrug = 'Paracetamol';

  final List<String> drugs = [
    'Paracetamol',
    'Amoxicillin',
    'Ibuprofen',
    'Cetirizine',
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text('Prescription Generator'),
        backgroundColor: Colors.black,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Patient Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            TextField(

              controller: patientController,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(

                hintText: 'Enter patient name',

                hintStyle: const TextStyle(color: Colors.white54),

                filled: true,

                fillColor: const Color(0xFF1E1E1E),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Select Drug',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(

              value: selectedDrug,

              dropdownColor: const Color(0xFF1E1E1E),

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(

                filled: true,

                fillColor: const Color(0xFF1E1E1E),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              items: drugs.map((drug) {

                return DropdownMenuItem(
                  value: drug,
                  child: Text(drug),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedDrug = value!;
                });

              },
            ),

            const SizedBox(height: 25),

            const Text(
              'Instruction',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            TextField(

              controller: instructionController,

              maxLines: 3,

              style: const TextStyle(color: Colors.white),

              decoration: InputDecoration(

                hintText: 'Example: 3x1 after meal',

                hintStyle: const TextStyle(color: Colors.white54),

                filled: true,

                fillColor: const Color(0xFF1E1E1E),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: () {

                  showDialog(

                    context: context,

                    builder: (_) {

                      return AlertDialog(

                        backgroundColor: const Color(0xFF1E1E1E),

                        title: const Text(
                          'Generated Prescription',
                          style: TextStyle(color: Colors.white),
                        ),

                        content: Text(

                          '''
Patient:
${patientController.text}

Drug:
$selectedDrug

Instruction:
${instructionController.text}
''',

                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      );
                    },
                  );
                },

                child: const Text(
                  'Generate Prescription',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}