// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/category_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/search_athletes.dart';
import 'package:des/src/Modules/Rank/services/get_scores.dart';
import 'package:des/src/Modules/Rank/widgets/rank_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<Map<String, dynamic>> athleteList = [];
  List<Map<String, dynamic>> filteredAthleteList = [];
  bool isLoading = true;
  String? selectedCategory;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadAthletes();
  }

  Future<void> loadAthletes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Tenta carregar do cache
    final cachedData = prefs.getString('cachedAthletes');
    if (cachedData != null) {
      final decoded = List<Map<String, dynamic>>.from(jsonDecode(cachedData));
      setState(() {
        athleteList = decoded;
        filteredAthleteList = decoded;
        isLoading = false;
      });
      log("Carregado do cache");
      return;
    }

    if (token != null && token.isNotEmpty) {
      try {
        final restClient = RestClient(token: token);
        final getScoresService = GetScoresService(restClient);

        // Usa o fetchAthletes do seu serviço com endpoint 'api/participants'
        final data = await getScoresService.fetchAthletes(getAll: true);

        // Ordena pela pontuação overall, caso tenha
        data.sort((a, b) => (b['overall'] ?? 0).compareTo(a['overall'] ?? 0));

        await prefs.setString('cachedAthletes', jsonEncode(data));

        if (!mounted) return;
        setState(() {
          athleteList = data;
          filteredAthleteList = data;
          isLoading = false;
        });
      } catch (e) {
        log("Erro ao carregar atletas: $e");
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    } else {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void filterAthletes() {
    setState(() {
      final catFilter =
          selectedCategory?.toLowerCase().replaceAll(RegExp(r'[\s\-]'), '') ??
              '';
      final searchLower = searchQuery.toLowerCase();

      filteredAthleteList = athleteList.where((athlete) {
        final cat = athlete['category']
                ?.toString()
                .toLowerCase()
                .replaceAll(RegExp(r'[\s\-]'), '') ??
            '';
        final user = athlete['user'];
        final name = user != null
            ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.toLowerCase()
            : '';

        final matchesCategory = catFilter.isEmpty || cat.contains(catFilter);
        final matchesSearch = searchLower.isEmpty || name.contains(searchLower);

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void filterAthletesByCategory(String? category) {
    selectedCategory = category;
    filterAthletes();
  }

  void onSearchChanged(String value) {
    searchQuery = value;
    filterAthletes();
  }

  Color _getBorderColorByRank(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return const Color(0XFFA6B92E);
    }
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
                Colors.black,
                Colors.black,
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
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  "RANKING DOS ATLETAS",
                  style: principalFont.bold(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                SearchAthletes(onChanged: onSearchChanged),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 15,
                      child: FilterCategory(
                        selectedCategory: selectedCategory,
                        onCategorySelected: filterAthletesByCategory,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Color(0XFFA6B92E),
                        ))
                      : filteredAthleteList.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum atleta encontrado.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: filteredAthleteList.length,
                              itemBuilder: (context, index) {
                                final athlete = filteredAthleteList[index];
                                if (athlete == null ||
                                    athlete['user'] == null) {
                                  return const SizedBox.shrink();
                                }

                                final user = athlete['user'];
                                final team = athlete['team'] ?? {};

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 6.0),
                                  child: RankCard(
                                    name:
                                        '${user['name'] ?? ''} ${user['last_name'] ?? ''}',
                                    position: athlete['position'] ?? 'N/A',
                                    team: team['name'] ?? 'Sem time',
                                    category:
                                        athlete['category'] ?? 'Sem categoria',
                                    score: (athlete['overall'] ?? 0).round(),
                                    ranking: index + 1,
                                    borderColor:
                                        _getBorderColorByRank(index + 1),
                                    photoUrl: user['photo_temp'] ?? '',
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
