import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/GlobalWidgets/title_layout_vetor.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_all_subcriteria.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/measurable/card/measurable_card.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/quantitative/card/quantitative_card.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/questionnaire/card/questionnaire_card.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/subjetive/card/subjetive_card.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/SubcriteriaCardGlobal/subcriteria_card.dart';
import 'package:flutter/material.dart';

class SubcriteriaTechnicalPage extends StatefulWidget {
  const SubcriteriaTechnicalPage({super.key});

  @override
  State<SubcriteriaTechnicalPage> createState() =>
      _SubcriteriaTechnicalPageState();
}

class _SubcriteriaTechnicalPageState extends State<SubcriteriaTechnicalPage> {
  late Future<List<dynamic>> _subCriteriaFuture;
  Map<String, dynamic>? selectedSubcriteria;

  @override
  void initState() {
    super.initState();
    _subCriteriaFuture = getSubcriteria(criterionId: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const ExitButton(),
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black,
                Colors.black,
                // ignore: deprecated_member_use
                const Color(0xFF42472B).withOpacity(0.5),
              ],
            ),
          ),
        ),
        title: Image.asset(
          Assets.homelogo,
          width: 250,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.background1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 350,
                  height: 60,
                  child: CustomPaint(
                    painter: TitleVetor('Avaliações Técnicas'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _subCriteriaFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0XFFA6B92E),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Erro ao carregar critérios',
                            style: TextStyle(color: Colors.white)),
                      );
                    }

                    final subCriteriaList = snapshot.data ?? [];

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 40),
                      itemCount: subCriteriaList.length,
                      itemBuilder: (context, index) {
                        final subCriteria = subCriteriaList[index];
                        final bool isSelected = selectedSubcriteria != null &&
                            selectedSubcriteria!['id'] == subCriteria['id'];

                        final List<dynamic> measurableItems = isSelected
                            ? (subCriteria['items'] as List)
                                .where((item) => item['aspect'] == 'measurable')
                                .toList()
                            : [];

                        final List<dynamic> quantitativeItems = isSelected
                            ? (subCriteria['items'] as List)
                                .where(
                                    (item) => item['aspect'] == 'quantitative')
                                .toList()
                            : [];

                        final List<dynamic> subjectiveItems = isSelected
                            ? (subCriteria['items'] as List)
                                .where((item) => item['aspect'] == 'subjective')
                                .toList()
                            : [];

                        final List<dynamic> questionnaireItems = isSelected
                            ? (subCriteria['items'] as List)
                                .where(
                                    (item) => item['aspect'] == 'questionnaire')
                                .toList()
                            : [];

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: SubcriteriaCard(
                                subcriteria: subCriteria,
                                onPressed: () {
                                  setState(() {
                                    selectedSubcriteria =
                                        isSelected ? null : subCriteria;
                                  });
                                },
                              ),
                            ),
                            if (isSelected)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    ...measurableItems.map((item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: MeasurableCard(
                                              itemName: item['name'],
                                              itemId: item["id"]),
                                        )),
                                    ...quantitativeItems.map((item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: QuantitativeCard(
                                            itemName: item['name'],
                                            itemId: item[
                                                'id'], // <-- aqui o id do item para o submit funcionar
                                          ),
                                        )),
                                    ...subjectiveItems.map((item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: SubjetiveCard(
                                              itemName: item['name']),
                                        )),
                                    ...questionnaireItems.map((item) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: QuestionnaireCard(
                                              itemName: item['name']),
                                        )),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
