import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';
import 'package:law_counsel_app/core/theming/text_style_manger.dart';
import 'package:law_counsel_app/core/widgets/search.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc/LawyerMangment_State.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/ProfileLawyer.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';

class LawyersShow extends StatelessWidget {
  const LawyersShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.btnColor),
        backgroundColor: AppColors.primaryColor,
        title: Text("كل المحامين", style: AppTextStyles.font18WhiteNormal),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.sp),
            child: TextField(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: UniversalSearchDelegate(
                    collectionName: 'lawyers',
                    searchableFields: ['name'],
                    resultBuilder: (data) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data['profileImageUrl'] ?? '',
                          ),
                        ),
                        title: Text(data['name'] ?? ''),
                        subtitle: Text(data['specialization'] ?? ''),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileLawyer(lawyerId: data['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'بحث...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LawyerManagementBloc, LawyerManagementState>(
              builder: (context, state) {
                if (state is LawyerManagementLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is LawyerManagementLoaded) {
                  final lawyers = state.lawyers;

                  return ListView.builder(
                    itemCount: lawyers.length,
                    itemBuilder: (context, index) {
                      final lawyer = lawyers[index];

                      return Card(
                        margin: EdgeInsets.all(10.sp),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            leading: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileLawyer(lawyerId: lawyer.id!),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  lawyer.profileImageUrl ?? "",
                                ),
                              ),
                            ),

                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                lawyer.name,
                                style: AppTextStyles.font14PrimaryBold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "التخصصات: ${lawyer.specializations.join(", ")}",
                                  style: AppTextStyles.font12PrimarySemiBold,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${lawyer.price} جنية",
                                  style: AppTextStyles.font14PrimarySemiBold,
                                ),
                              ],
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 10.0.sp),
                              child: ConsultationButton(
                                lawyerId: lawyer.id ?? "",
                              ),
                            ),
                            isThreeLine: true,
                            minLeadingWidth: 0,
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is LawyerManagementError) {
                  return Center(child: Text("خطأ: ${state.message}"));
                } else {
                  return Center(
                    child: Text(
                      "لا يوجد بيانات.",
                      style: AppTextStyles.font24WhiteSemiBold,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
