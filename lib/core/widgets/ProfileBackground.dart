import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class Profilebackground extends StatelessWidget {
  final Widget? child;

  const Profilebackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: const BoxDecoration(color: AppColors.primaryColor),
        ),
        Positioned(
          top: 50,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.only(top: 100),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}
