import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Athletes/service/get_athletes.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/category_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/gender_filter.dart';
import 'package:des/src/Modules/Athletes/widgets/Filters/team_filter.dart';
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
        final data = await GetAthletes.fetchAthletes(token!);
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
                  "LISTA DE ATLETAS",
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
                    const FilterGender(),
                    const SizedBox(width: 10),
                    FilterCategory(
                      selectedCategory: selectedCategory,
                      onCategorySelected:
                          filterAthletesByCategory, //FILTRO DE CATEGORIA DO ATLETA
                    ),
                    const SizedBox(width: 10),
                    const TeamFilter(),
                  ],
                ),
                const SizedBox(height: 30),
                isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredAthleteList.length,
                          itemBuilder: (context, index) {
                            final athlete = filteredAthleteList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Center(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: AthletesCard(athlete: athlete),
                                ),
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
