import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class RankCard extends StatelessWidget {
  final String name;
  final String position;
  final String team;
  final int ranking;
  final int score;
  final String category;
  final Color borderColor;
  final String photoUrl;

  const RankCard({
    super.key,
    required this.name,
    required this.position,
    required this.team,
    required this.ranking,
    required this.score,
    required this.category,
    required this.borderColor,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.95;
    final cardHeight = 90.0; // altura fixa para padronizar

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 8),
          top: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$ranking',
                  style: principalFont.bold(color: Colors.black, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Icon(Icons.workspace_premium, size: 18, color: borderColor),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0XFFb0c32e), width: 2),
              image: photoUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(photoUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
              color: photoUrl.isEmpty ? const Color(0xFFB0B0B0) : null,
            ),
            child: photoUrl.isEmpty
                ? const Icon(Icons.account_circle_outlined,
                    size: 50, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: secondFont.bold(color: Colors.black, fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$position - $category',
                  style: principalFont.bold(color: Colors.black, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  team,
                  style: principalFont.bold(color: Colors.black, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: borderColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$score',
              style: principalFont.bold(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
