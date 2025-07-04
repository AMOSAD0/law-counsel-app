import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/ContainerUser.dart';
import 'package:law_counsel_app/core/widgets/minBackground.dart';

class SelectUser extends StatelessWidget {
  const SelectUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(children: [minBackground()]),
          const SizedBox(height: 60),
          const Text("برجاء الإختيـــار", style: TextStyleManger.selectText),
          const SizedBox(height: 40),
          SelectableUser(),
        ],
      ),
    );
  }
}
