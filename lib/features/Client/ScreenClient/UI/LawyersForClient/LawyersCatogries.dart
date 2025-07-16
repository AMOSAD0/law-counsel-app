import 'package:flutter/material.dart';
import 'package:law_counsel_app/core/widgets/ListLawyer.dart';
class Lawyerscatogries extends StatefulWidget {
  const Lawyerscatogries({super.key});

  @override
  State<Lawyerscatogries> createState() => _LawyerscatogriesState();
}

class _LawyerscatogriesState extends State<Lawyerscatogries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: LawyerCategoryList(),
    );
  }
}
