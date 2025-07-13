import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/widgets/Conslution/Messages.dart';
import 'package:law_counsel_app/core/widgets/Conslution/requestClient.dart';

class Consolation extends StatefulWidget {
  const Consolation({super.key});

  @override
  State<Consolation> createState() => _ConsolationState();
}

class _ConsolationState extends State<Consolation> {
  int _selectedTopTabIndex = 1;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الاستشارات',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTopTabIndex = 0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _selectedTopTabIndex == 0
                              ? AppColors.primaryColor
                              : AppColors.lightBlueWithOpacity,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'الطلبات',
                          style: TextStyle(
                            color: _selectedTopTabIndex == 0
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTopTabIndex = 1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _selectedTopTabIndex == 1
                              ? AppColors.primaryColor
                              : AppColors.lightBlueWithOpacity,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'الرسائل',
                          style: TextStyle(
                            color: _selectedTopTabIndex == 1
                                ? Colors.white
                                : const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _selectedTopTabIndex == 0
                ? Requests()
                : Messages(),
          ),
        ],
      ),
    );
  }

 
}
