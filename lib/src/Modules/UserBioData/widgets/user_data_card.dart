import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class ViewBiological extends StatelessWidget {
  final Map<String, dynamic>? item16;
  final Map<String, dynamic>? item17;

  const ViewBiological({
    super.key,
    required this.item16,
    required this.item17,
  });

  @override
  Widget build(BuildContext context) {
    String getScore(Map<String, dynamic>? judgment) {
      final score = judgment?['score'];
      final unit = judgment?['item']?['measurement_unit'] ?? '';
      return score != null ? '$score $unit' : 'Sem nota';
    }

    String? imcResult() {
      final alturaStr = item16?['score']?.toString();
      final pesoStr = item17?['score']?.toString();

      if (alturaStr != null && pesoStr != null) {
        final altura = double.tryParse(alturaStr);
        final peso = double.tryParse(pesoStr);

        if (altura != null && peso != null && altura > 0) {
          final alturaEmMetros = altura > 3 ? altura / 100 : altura;
          final imc = peso / (alturaEmMetros * alturaEmMetros);
          return imc.toStringAsFixed(1);
        }
      }

      return null;
    }

    String? imcClassification() {
      final imcStr = imcResult();
      if (imcStr == null) return null;

      final imc = double.tryParse(imcStr);
      if (imc == null) return null;

      if (imc < 18.5) return "Abaixo do peso";
      if (imc < 24.9) return "Peso normal";
      if (imc < 29.9) return "Sobrepeso";
      if (imc < 34.9) return "Obesidade grau 1";
      if (imc < 39.9) return "Obesidade grau 2";
      return "Obesidade grau 3";
    }

    final user = item16?['user'] ?? item17?['user'];
    final userName = user?['name'] ?? 'Sem nome';
    final userPhoto = user?['photo_temp'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 400,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: const Color(0XFFb0c32e)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header com nome e foto
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0XFFb0c32e),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),

          const SizedBox(height: 12),

          // Scores
          Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: Image.network(
                      userPhoto ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person,
                            size: 48, color: Colors.white);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                userName,
                style: secondFont.bold(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: 150,
                height: 1,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Altura",
                        style: principalFont.bold(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(getScore(item16),
                          style: secondFont.bold(
                              color: Colors.white, fontSize: 15)),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Peso",
                        style: principalFont.bold(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "${getScore(item17)} kg",
                        style:
                            secondFont.bold(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "IMC",
                        style: principalFont.bold(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        imcResult() ?? 'Sem dados',
                        style:
                            secondFont.bold(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                width: 150,
                height: 1,
                color: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                "Classifcação IMC",
                style: principalFont.bold(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                imcClassification() ?? 'Sem dados',
                style: secondFont.bold(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
