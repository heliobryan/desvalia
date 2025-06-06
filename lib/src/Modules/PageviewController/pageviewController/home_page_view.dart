// ignore_for_file: prefer_final_fields, camel_case_types
import 'package:des/src/Modules/Agenda/screens/agenda_page.dart';
import 'package:des/src/Modules/Athletes/screens/athletes_page.dart';
import 'package:des/src/Modules/Marketplace/screens/marketplace.dart';
import 'package:des/src/Modules/Rank/screens/rank_page.dart';
import 'package:flutter/material.dart';

class pageviewController extends StatefulWidget {
  const pageviewController({
    super.key,
  });

  @override
  State<pageviewController> createState() => _pageviewControllerState();
}

class _pageviewControllerState extends State<pageviewController> {
  int currentPageIndex = 0;

  late final List<Widget> _screens;

  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _screens = [
      const AgendaPage(),
      const AthletesPage(),
      const RankPage(),
      const MarketPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: const Color(0XFFA6B92E),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 75,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          _buildVerticalDivider(),
          _buildExpandedSquareButton(
            icon: Icons.analytics,
            label: 'Avaliações',
            isSelected: currentPageIndex == 0,
            onTap: () => _navigateToPage(0),
          ),
          _buildExpandedSquareButton(
            icon: Icons.group_outlined,
            label: 'Atletas',
            isSelected: currentPageIndex == 1,
            onTap: () => _navigateToPage(1),
          ),
          _buildVerticalDivider(),
          _buildExpandedSquareButton(
            icon: Icons.emoji_events,
            label: 'Ranking',
            isSelected: currentPageIndex == 2,
            onTap: () => _navigateToPage(2),
          ),
          _buildVerticalDivider(),
          _buildExpandedSquareButton(
            icon: Icons.store,
            label: 'Loja',
            isSelected: currentPageIndex == 3,
            onTap: () => _navigateToPage(3),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedSquareButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : const Color(0XFFA6B92E),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
                size: 45,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OUTFIT',
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 2, // Largura da linha
      color: Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 0),
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
