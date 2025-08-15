// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Athletes/service/get_athletes.dart';
import 'package:des/src/Modules/Athletes/widgets/athletes_card.dart';
import 'package:des/src/Modules/Athletes/widgets/search_athletes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AthletesPage extends StatefulWidget {
  const AthletesPage({super.key});

  @override
  State<AthletesPage> createState() => _AthletesPageState();
}

class _AthletesPageState extends State<AthletesPage> {
  List<Map<String, dynamic>> athleteList = [];
  List<Map<String, dynamic>> filteredAthleteList = [];
  bool isLoading = true;
  String? token;
  String? selectedCategory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadAthletes();
  }

  Future<void> loadAthletes() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final cachedData = prefs.getString('cachedAthletes');
    if (cachedData != null) {
      try {
        final decoded = List<Map<String, dynamic>>.from(jsonDecode(cachedData));
        athleteList = decoded;
        log("Carregado do cache");
      } catch (e) {
        log("Erro ao decodificar cache: $e");
        athleteList = [];
      }
    } else if (token != null && token.isNotEmpty) {
      try {
        final restClient = RestClient(token: token);
        final athletesService = GetAthletesService(restClient);
        final data = await athletesService.fetchAthletes();

        await prefs.setString('cachedAthletes', jsonEncode(data));
        athleteList = data;
      } catch (e) {
        log('Erro ao carregar atletas: $e');
        athleteList = [];
      }
    } else {
      log("Token não encontrado.");
      athleteList = [];
    }

    // aplica filtros iniciais (categoria + busca vazia)
    _applyFilters();

    setState(() {
      isLoading = false;
    });
  }

  void _applyFilters() {
    final q = (searchQuery).trim().toLowerCase();

    filteredAthleteList = athleteList.where((athlete) {
      // Category filter
      if (selectedCategory != null && selectedCategory!.isNotEmpty) {
        final cat = athlete['category'];
        if (cat == null || cat.toString().trim() != selectedCategory!.trim()) {
          return false;
        }
      }

      // Search filter
      if (q.isNotEmpty) {
        final user = athlete['user'] ?? {};
        final fullName = '${user['name'] ?? ''} ${user['last_name'] ?? ''}'
            .trim()
            .toLowerCase();
        // também buscar por time, posição ou outros campos se quiser
        final team = athlete['team']?['name']?.toString().toLowerCase() ?? '';
        final position = (athlete['position'] ?? '').toString().toLowerCase();

        // match if any contains the query
        if (!fullName.contains(q) &&
            !team.contains(q) &&
            !position.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void filterAthletesByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
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
                const Color(0xFF42472B).withOpacity(0.5),
                const Color(0xFF42472B).withOpacity(0.5),
                Colors.black,
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
      backgroundColor: const Color(0xFF121212),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "LISTA DE ATLETAS",
                  style: principalFont.bold(
                    fontSize: 20,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                const SizedBox(height: 15),
                SearchAthletes(
                  onChanged: _onSearchChanged,
                  initialValue: searchQuery,
                ),
                const SizedBox(height: 5),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     const Flexible(
                //       flex: 3,
                //       child: FilterGender(),
                //     ),
                //     const SizedBox(width: 10),
                //     Flexible(
                //       flex: 4,
                //       child: FilterCategory(
                //         selectedCategory: selectedCategory,
                //         onCategorySelected: filterAthletesByCategory,
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     const Flexible(
                //       flex: 3,
                //       child: TeamFilter(),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                if (isLoading) ...[
                  const CircularProgressIndicator(color: Colors.white)
                ] else if (filteredAthleteList.isEmpty) ...[
                  const Text(
                    'Nenhum atleta encontrado.',
                    style: TextStyle(color: Colors.white),
                  )
                ] else ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredAthleteList.length,
                      itemBuilder: (context, index) {
                        final athlete = filteredAthleteList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: AthletesCard(athlete: athlete),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
