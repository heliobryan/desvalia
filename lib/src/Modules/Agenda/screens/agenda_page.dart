// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:developer';
import 'package:des/src/Modules/Agenda/services/get_evaluations.dart';
import 'package:des/src/Modules/Agenda/widgets/agenda_card.dart';
import 'package:des/src/Modules/Agenda/widgets/agenda_month_changer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({
    super.key,
  });

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  List eventList = [];
  List filteredEventList = [];
  bool isLoading = true;
  String? token;
  int selectedMonth = DateTime.now().month;
  Map<String, dynamic> userDados = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initPage();
  }

  Future<void> initPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    await userInfo();
    if (token != null) {
      try {
        final evaluations = await GetEvaluations.fetchEvaluations(token!);
        setState(() {
          eventList = evaluations;
          filteredEventList = evaluations;
          isLoading = false;
        });
      } catch (e) {
        log('Erro ao buscar avaliações: $e');
        setState(() => isLoading = false);
      }
    } else {
      log('Token nulo! Não foi possível buscar avaliações.');
      setState(() => isLoading = false);
    }
  }

  Future<void> userInfo() async {
    if (token == null) return;
    try {
      String api = dotenv.get('API_HOST', fallback: '');
      var url = Uri.parse('${api}api/user');

      var response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          userDados = json;
        });
      }
    } catch (e) {
      log('Erro em userInfo: $e');
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
                  image: AssetImage(Assets.background1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Text(
                'Avaliações',
                style: principalFont.bold(color: Colors.white, fontSize: 25),
              ),
              const SizedBox(height: 20),
              MonthChanger(
                onMonthChanged: (month) {
                  setState(() {
                    selectedMonth = month;
                  });
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: Builder(
                          builder: (context) {
                            List uniqueEvents = [];
                            Set seenNames = {};

                            for (var event in eventList) {
                              final name = event["eventday"]["event"]["name"];
                              final dateString = event["eventday"]["date"];

                              if (dateString != null) {
                                final eventDate = DateTime.tryParse(dateString);
                                if (eventDate != null &&
                                    eventDate.month == selectedMonth) {
                                  if (name != null &&
                                      !seenNames.contains(name)) {
                                    seenNames.add(name);
                                    uniqueEvents.add(event);
                                  }
                                }
                              }
                            }
                            if (uniqueEvents.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Nenhuma avaliação agendada para este mês.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: uniqueEvents.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final event = uniqueEvents[index];
                                final String name = event["eventday"]["event"]
                                        ["name"] ??
                                    "Sem nome";
                                final String date = event["eventday"]["date"] ??
                                    "Data não disponível";
                                return AgendaCard(
                                  title: name,
                                  date: date,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
            ]),
          ),
        ],
      ),
    );
  }
}
