import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';

class SpecializationSelector extends StatefulWidget {
  const SpecializationSelector({super.key});

  @override
  State<SpecializationSelector> createState() => _SpecializationSelectorState();
}

class _SpecializationSelectorState extends State<SpecializationSelector> {
  final List<String> _availableSpecializations = ['جنائي', 'مدني', 'تجاري'];
  String? _selectedSpecialization = 'جنائي';
  final List<String> _selectedList = [];

  void _addSpecialization() {
    if (_selectedSpecialization != null &&
        !_selectedList.contains(_selectedSpecialization)) {
      setState(() {
        _selectedList.add(_selectedSpecialization!);
      });
    }
  }

  void _removeSpecialization(String value) {
    setState(() {
      _selectedList.remove(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "• مجال التخصص",
                  style: AppTextStyles.font20PrimarySemiBold,
                ),
              ],
            ),
            verticalSpace(10),
            Row(
              children: [
                Container(
                  width: 140.w,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: DropdownButton<String>(
                      value: _selectedSpecialization,
                      icon: Row(
                        children: [
                          horizontalSpace(45),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      items:
                          _availableSpecializations.map((spec) {
                            return DropdownMenuItem(
                              value: spec,
                              child: Text(
                                spec,
                                style: AppTextStyles.font18PrimaryNormal,
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpecialization = value;
                        });
                      },
                    ),
                  ),
                ),
                horizontalSpace(20),
                ElevatedButton(
                  onPressed: _addSpecialization,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23293C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text("إضافة",style: AppTextStyles.font18WhiteNormal,),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  _selectedList.map((spec) {
                    return Chip(
                      label: Text(spec),
                      labelStyle: AppTextStyles.font18PrimaryNormal,
                      backgroundColor: AppColors.whiteColor,
                      shape: StadiumBorder(
                        side: BorderSide(color: AppColors.primaryColor),
                      ),
                      deleteIcon: const Icon(Icons.close, color: Colors.red),
                      onDeleted: () => _removeSpecialization(spec),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
