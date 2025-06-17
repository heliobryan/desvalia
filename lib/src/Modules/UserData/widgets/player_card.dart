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
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth * 0.9;
        if (maxWidth > 350) maxWidth = 350;

        double headerWidth = maxWidth * 0.95;
        double photoWidth = maxWidth * 0.7;
        double photoHeight = photoWidth * 0.9;
        double statsWidth = maxWidth * 0.7;
        double radarSize = maxWidth * 0.5;

        final rit = widget.stats['rit']?.toString() ?? '--';
        final fin = widget.stats['fin']?.toString() ?? '--';
        final pas = widget.stats['pas']?.toString() ?? '--';
        final dri = widget.stats['dri']?.toString() ?? '--';
        final agi = widget.stats['agi']?.toString() ?? '--';
        final fis = widget.stats['fis']?.toString() ?? '--';

        return Container(
          width: maxWidth,
          margin: const EdgeInsets.symmetric(vertical: 6),
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
          child: Column(
            children: [
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipPath(
                    clipper: LeftParallelogramClipper(),
                    child: Container(
                      width: headerWidth,
                      height: 40,
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          '${widget.name} ${widget.lastName}',
                          style: secondFont.bold(
                            color: Colors.white,
                            fontSize: maxWidth * 0.05,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                width: photoWidth,
                height: photoHeight,
                color: Colors.white,
                child: Stack(
                  children: [
                    Image.network(
                      widget.photo,
                      width: photoWidth,
                      height: photoHeight,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: photoWidth,
                      height: photoHeight,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0XFFb0c32e), width: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                width: statsWidth,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Row(
                  children: [
                    Container(
                      width: statsWidth * 0.2,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.overall!.toStringAsFixed(1),
                            style: secondFont.bold(
                              color: Colors.white,
                              fontSize: maxWidth * 0.055,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.position,
                            style: secondFont.bold(
                              color: Colors.white,
                              fontSize: maxWidth * 0.04,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: statsWidth * 0.1),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn("RIT", rit, maxWidth),
                              _buildStatColumn("FIN", fin, maxWidth),
                              _buildStatColumn("PAS", pas, maxWidth),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatColumn("DRI", dri, maxWidth),
                              _buildStatColumn("AGI", agi, maxWidth),
                              _buildStatColumn("FIS", fis, maxWidth),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                height: radarSize,
                width: radarSize,
                child: RadarChart(
                  ticks: const [60, 70, 80, 90, 100, 110],
                  features: const ['RIT', 'FIN', 'PAS', 'DRI', 'AGI', 'FIS'],
                  data: [
                    [
                      double.tryParse(widget.stats['rit']?.toString() ?? '0') ??
                          0,
                      double.tryParse(widget.stats['fin']?.toString() ?? '0') ??
                          0,
                      double.tryParse(widget.stats['pas']?.toString() ?? '0') ??
                          0,
                      double.tryParse(widget.stats['dri']?.toString() ?? '0') ??
                          0,
                      double.tryParse(widget.stats['agi']?.toString() ?? '0') ??
                          0,
                      double.tryParse(widget.stats['fis']?.toString() ?? '0') ??
                          0,
                    ],
                  ],
                  outlineColor: Colors.grey,
                  graphColors: const [Color(0xFFb0c32e)],
                  featuresTextStyle: principalFont.bold(
                      color: Colors.white, fontSize: maxWidth * 0.025),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value, double maxWidth) {
    return Column(
      children: [
        Text(
          label,
          style: principalFont.bold(
            color: Colors.black,
            fontSize: maxWidth * 0.03,
          ),
        ),
        Container(
          width: maxWidth * 0.12,
          padding: const EdgeInsets.symmetric(vertical: 4),
          color: Colors.black,
          child: Center(
            child: Text(
              value,
              style: secondFont.bold(
                color: Colors.white,
                fontSize: maxWidth * 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
