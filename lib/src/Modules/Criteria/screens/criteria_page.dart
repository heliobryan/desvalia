import 'dart:convert';

import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Criteria/services/get_criteria.dart';
import 'package:des/src/Modules/Criteria/widgets/criteria_card.dart';
import 'package:des/src/Modules/Subcriteria/Mental/screens/subcriteria_mental_page.dart';
import 'package:des/src/Modules/Subcriteria/Physical/screens/subcriteria_physical_page.dart';
import 'package:des/src/Modules/Subcriteria/Tactical/screens/subcriteria_tactical_page.dart';
import 'package:des/src/Modules/Subcriteria/Technical/screens/subcriteria_technical_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CriteriaPage extends StatefulWidget {
  const CriteriaPage({super.key});

  @override
  State<CriteriaPage> createState() => _CriteriaPageState();
}

class _CriteriaPageState extends State<CriteriaPage> {
  late Future<List<dynamic>> _criteriaFuture;

  @override
  void initState() {
    super.initState();
    _loadCriteria();
  }

  void _loadCriteria() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final restClient = RestClient(token: token);
    final criteriaService = CriteriaService(restClient);

    // Tentar carregar do cache
    final cachedString = prefs.getString('cachedCriteria');
    if (cachedString != null) {
      final List<dynamic> cachedData =
          List<dynamic>.from(jsonDecode(cachedString));
      setState(() {
        _criteriaFuture = Future.value(cachedData);
      });
      return;
    }

    // Se não tiver cache, busca da API e salva no cache
    setState(() {
      _criteriaFuture = criteriaService.getCriteria().then((data) async {
        await prefs.setString('cachedCriteria', jsonEncode(data));
        return data;
      });
    });
  }

  void navigateToPage(String criteriaName) {
    switch (criteriaName) {
      case 'Físico':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SubcriteriaPhysicalPage()));
        break;
      case 'Técnico':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SubcriteriaTechnicalPage()));
        break;
      case 'Mental':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SubcriteriaMentalPage()));
        break;
      case 'Tático':
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => SubcriteriaTacticalPage()));
        break;
      default:
        break;
    }
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
          FutureBuilder<List<dynamic>>(
              future: _criteriaFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0XFFA6B92E),
                  ));
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar critérios',
                          style: TextStyle(color: Colors.white)));
                }

                final criteriaList = snapshot.data ?? [];

                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 200),
                  itemCount: criteriaList.length,
                  itemBuilder: (context, index) {
                    final criteria = criteriaList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16),
                      child: CriteriaCard(
                        criterias: criteria,
                        onTap: () => navigateToPage(criteria['name']),
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
