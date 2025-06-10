// ignore_for_file: deprecated_member_use
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/UserData/widgets/paralelogram_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class PlayerCard extends StatefulWidget {
  final int participantID;
  final String name;
  final String lastName;
  final String photo;
  final double? overall;
  final String position;
  final Map<String, dynamic> stats;
  const PlayerCard(
      {super.key,
      required this.participantID,
      required this.name,
      required this.lastName,
      required this.stats,
      required this.photo,
      required this.overall,
      required this.position});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  @override
  Widget build(BuildContext context) {
    final rit = widget.stats['rit']?.toString() ?? '--';
    final fin = widget.stats['fin']?.toString() ?? '--';
    final pas = widget.stats['pas']?.toString() ?? '--';
    final dri = widget.stats['dri']?.toString() ?? '--';
    final agi = widget.stats['agi']?.toString() ?? '--';
    final fis = widget.stats['fis']?.toString() ?? '--';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0XFFb0c32e),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
      ),
      width: 425,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipPath(
                clipper: LeftParallelogramClipper(),
                child: Container(
                  width: 400,
                  height: 50,
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      '${widget.name} ${widget.lastName}',
                      style: secondFont.bold(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 320,
            height: 300,
            color: Colors.white,
            child: Center(
              child: Center(
                child: Stack(children: [
                  Image.network(
                    widget.photo,
                    width: 300,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Container(
                      width: 300,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Color(0XFFb0c32e), width: 2),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: 320,
            height: 100,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.overall!.toStringAsFixed(1),
                            style: secondFont.bold(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            widget.position,
                            style: secondFont.bold(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "RIT",
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      rit,
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "FIN",
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      fin,
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "PAS",
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      pas,
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "DRI",
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      dri,
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  "AGI",
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      agi,
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  fis,
                                  style: principalFont.bold(
                                      color: Colors.black, fontSize: 13),
                                ),
                                Container(
                                  width: 40,
                                  color: Colors.black,
                                  child: Center(
                                    child: Text(
                                      "90",
                                      style: secondFont.bold(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: 250,
            width: 250,
            child: RadarChart(
              ticks: const [60, 70, 80, 90, 100, 110],
              features: const ['RIT', 'FIN', 'PAS', 'DRI', 'AGI', 'FIS'],
              data: [
                [
                  double.tryParse(widget.stats['rit']?.toString() ?? '0') ?? 0,
                  double.tryParse(widget.stats['fin']?.toString() ?? '0') ?? 0,
                  double.tryParse(widget.stats['pas']?.toString() ?? '0') ?? 0,
                  double.tryParse(widget.stats['dri']?.toString() ?? '0') ?? 0,
                  double.tryParse(widget.stats['agi']?.toString() ?? '0') ?? 0,
                  double.tryParse(widget.stats['fis']?.toString() ?? '0') ?? 0,
                ],
              ],
              outlineColor: Colors.grey,
              graphColors: const [Color(0xFFb0c32e)],
              featuresTextStyle:
                  principalFont.bold(color: Colors.white, fontSize: 12),
            ),
          )
        ],
      ),
    );
  }
}
