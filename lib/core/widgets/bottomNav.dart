import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/Profile.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/homeClient.dart';
import 'package:law_counsel_app/features/Consultion/UI/MyConsultion.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';
import 'package:law_counsel_app/features/chatbot/ui/chatbot.dart';

class BottomNavBarApp extends StatefulWidget {
  const BottomNavBarApp({super.key});

  @override
  State<BottomNavBarApp> createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    Homeclient(),
    MyConsultation(),
    ChatbotScreen(),
    ProfileClient(),
  ];

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(AppAssets.home)),
      activeIcon: ImageIcon(AssetImage(AppAssets.activeHome)),
      label: 'الرئيسية',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(AppAssets.consolation)),
      activeIcon: ImageIcon(AssetImage(AppAssets.activeConsolation)),
      label: 'استشارتي',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(AppAssets.chatbot)),
      activeIcon: ImageIcon(AssetImage(AppAssets.activeChatbot)),
      label: 'شات بوت',
    ),
    BottomNavigationBarItem(
      icon: ImageIcon(AssetImage(AppAssets.profile)),
      activeIcon: ImageIcon(AssetImage(AppAssets.activeProfile)),
      label: 'الملف الشخصي',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: items,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
