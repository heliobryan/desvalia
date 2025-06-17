// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/category_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/gender_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/team_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/search_athletes.dart';
import 'package:des/src/Modules/Rank/services/get_scores.dart';
import 'package:des/src/Modules/Rank/widgets/rank_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RankPage extends StatefulWidget {
  const RankPage({
    super.key,
  });

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<Map<String, dynamic>> athleteList = [];
  List<Map<String, dynamic>> filteredAthleteList = [];
  bool isLoading = true;
  String? token;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    loadAthletes();
  }

  Future<void> loadAthletes() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token != null) {
      try {
        final data = await GetScores.fetchAthletes(token!);

        data.sort((a, b) => (b['overall'] ?? 0).compareTo(a['overall'] ?? 0));

        setState(() {
          athleteList = data;
          filteredAthleteList = data;
          isLoading = false;
        });
      } catch (e) {
        log('Erro ao carregar atletas: $e');
        setState(() => isLoading = false);
      }
    } else {
      log("Token não encontrado.");
      setState(() => isLoading = false);
    }
  }

  void filterAthletesByCategory(String? category) {
    setState(() {
      selectedCategory = category;

      if (category == null || category.isEmpty) {
        filteredAthleteList = athleteList;
      } else {
        filteredAthleteList = athleteList.where((athlete) {
          return athlete['category'] != null &&
              athlete['category'].toString().trim() == category.trim();
        }).toList();
      }

      log("Lista filtrada: $filteredAthleteList");
    });
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
                  "RANKING DOS ATLETAS",
                  style: principalFont.bold(
                    fontSize: 20,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                const SizedBox(height: 15),
                const SearchAthletes(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: const FilterGender(),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 4,
                      child: FilterCategory(
                        selectedCategory: selectedCategory,
                        onCategorySelected: filterAthletesByCategory,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 3,
                      child: const TeamFilter(),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
