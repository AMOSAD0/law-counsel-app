import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/assets/assets_manger.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/Profile.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/UI/homeClient.dart';

import 'package:law_counsel_app/features/lawyer/home/homeLawyer.dart';
import 'package:law_counsel_app/features/lawyer/myArticals/myArticals.dart';
import 'package:law_counsel_app/features/lawyer/profileLawer/profileLawyer.dart';

import 'package:law_counsel_app/features/Consultion/UI/MyConsultion.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';
import 'package:law_counsel_app/features/chatbot/ui/chatbot.dart';


class BottomNavBarApp extends StatefulWidget {
 final bool isLawyer ;
   BottomNavBarApp({super.key,this.isLawyer=false});

  @override
  State<BottomNavBarApp> createState() => _BottomNavBarAppState();
}

class _BottomNavBarAppState extends State<BottomNavBarApp> {
  int _selectedIndex = 0;


  List<Widget> get _screens => !widget.isLawyer
      ? const [
          Homeclient(),
          MyConsultation(),
          ChatbotScreen(),
          ProfileClient(),
        ]
      : const [
         Homelawyer(),
         Homelawyer(),
         Myarticals(),
         LawyerProfilePage(),
        ];


   List<BottomNavigationBarItem>get items => !widget.isLawyer? [
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
  ]:[
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
      icon: ImageIcon(AssetImage(AppAssets.articls)),
      activeIcon: ImageIcon(AssetImage(AppAssets.activeArticls)),
      label: 'مقالاتي',
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
