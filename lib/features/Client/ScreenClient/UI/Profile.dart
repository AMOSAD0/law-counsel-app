import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/UploadImage.dart';
import 'package:law_counsel_app/core/helper/imagePickerApp.dart';
import 'package:law_counsel_app/core/widgets/ProfileBackground.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_event.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_state.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileclientBloc>().add(ProfileClientLoadEvent());
  }

  File? selectedImage;

  Future<void> _changeProfileImage() async {
    final image = await ImagePickerHelper.pickImageFromGallery();
    if (image == null) return;

    setState(() => selectedImage = image);

    final imageUrl = await ImageUploadHelper.uploadImageToKit(image);
    if (imageUrl != null) {
      context.read<ProfileclientBloc>().add(
        ProfileClientImageUpdateEvent(imageUrl: imageUrl),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("فشل رفع الصورة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileclientBloc, ProfileClientState>(
      listener: (context, state) {
        if (state is ProfileClientError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is ProfileClientSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is ProfileClientLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ProfileClientLoaded) {
          final client = state.client;

          return Scaffold(
            body: Stack(
              children: [
                const Profilebackground(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),

                        Positioned(
                          top: 100,
                          left: 20,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: client.imageUrl != null
                                ? NetworkImage(client.imageUrl!)
                                : const AssetImage(
                                        'assets/images/background.png',
                                      )
                                      as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton.icon(
                          onPressed: _changeProfileImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("تغيير الصورة"),
                        ),

                        Text(
                          client.name ?? "لا يوجد اسم",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          client.email ?? "لا يوجد بريد",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
               
                        Text(
                          client.phone ?? "لا يوجد رقم هاتف",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text("لا توجد بيانات متاحة")),
        );
      },
    );
  }
}
