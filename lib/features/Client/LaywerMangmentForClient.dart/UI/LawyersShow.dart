import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc.dart';
import 'package:law_counsel_app/features/Client/LaywerMangmentForClient.dart/LawyerMangment_bloc/LawyerMangment_State.dart';
import 'package:law_counsel_app/features/Consultion/UI/AddConsultion.dart';

class LawyersShow extends StatelessWidget {
  const LawyersShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("المحامين")),
      body: BlocBuilder<LawyerManagementBloc, LawyerManagementState>(
        
        builder: (context, state) {
          if (state is LawyerManagementLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LawyerManagementLoaded) {
            final lawyers = state.lawyers;

            return ListView.builder(
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
              print("loaded lawyer: ${lawyers}");
                final lawyer = lawyers[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        lawyer.profileImageUrl ?? "",
                      ),
                    ),
                    title: Text(
                      lawyer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text("التخصصات: ${lawyer.specializations.join(", ")}"),
                        const SizedBox(height: 4),
                        Text("400جنيه"),
                      ],
                    ),
                    trailing: ConsultationButton(lawyerId: lawyer.id ?? ""),
                    isThreeLine: true,
                  ),
                );
              },
            );
          } else if (state is LawyerManagementError) {
            return Center(child: Text("خطأ: ${state.message}"));
          } else {
            return const Center(child: Text("لا يوجد بيانات."));
          }
        },
      ),
    );
  }
}
//"سعر الخدمة: ${lawyer.name} جنيه"