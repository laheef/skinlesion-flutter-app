import 'package:flutter/material.dart';
import 'package:skinlesion/constants/colors.dart';

import 'package:skinlesion/screens/home/analysis/analyze_now_screen.dart';
import 'package:skinlesion/screens/home/home_screen.dart';
import 'package:skinlesion/screens/home/news/news_screen.dart';
import 'package:skinlesion/screens/home/settings/settings_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  NavigationMenuState createState() => NavigationMenuState();
}

class NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AnalyzeNowScreen(),
    const NewsScreen(),
    const SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        indicatorColor: dark ? Colors.white.withOpacity(0.1) : primaryColor.withOpacity(0.2),
        elevation: 0,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        overlayColor:WidgetStateProperty.all(primaryColor) ,
        backgroundColor: Colors.white,
        surfaceTintColor: primaryColor,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/microscope 1.png'),
              size: 35,
            ),
            label: 'Analyze',
          ),
          NavigationDestination(
            icon: ImageIcon(
              AssetImage('assets/news 1.png'),
              size: 30,
            ),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.settings_outlined,
              size: 30,
            ),
            label: 'Settings',
          ),
          
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
