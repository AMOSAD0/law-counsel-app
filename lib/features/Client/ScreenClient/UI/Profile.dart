import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:law_counsel_app/core/helper/UploadImage.dart';
import 'package:law_counsel_app/core/helper/imagePickerApp.dart';
import 'package:law_counsel_app/core/helper/spacing.dart';
import 'package:law_counsel_app/core/widgets/DerwerApp.dart';
import 'package:law_counsel_app/core/widgets/ProfileBackground.dart';
import 'package:law_counsel_app/features/Chat/UI/Chat.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_bloc.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_event.dart';
import 'package:law_counsel_app/features/Client/ScreenClient/LogicClient/Profile-block/ProfileClient_state.dart';
import 'package:law_counsel_app/core/theming/color_manger.dart';

class ProfileClient extends StatefulWidget {
  const ProfileClient({super.key});

  @override
  State<ProfileClient> createState() => _ProfileClientState();
}

class _ProfileClientState extends State<ProfileClient> {
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    context.read<ProfileclientBloc>().add(ProfileClientLoadEvent());
  }

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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      key: _scaffoldKey,
      drawer: DrwerApp(),
      body: BlocConsumer<ProfileclientBloc, ProfileClientState>(
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
            return Stack(
              children: [
                const Profilebackground(),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: client.imageUrl != null
                                ? NetworkImage(client.imageUrl!)
                                : const AssetImage(
                                        'assets/images/background.png',
                                      )
                                      as ImageProvider,
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt, size: 20),
                            onPressed: _changeProfileImage,
                            color: Colors.white,
                            padding: const EdgeInsets.all(3),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              shape: const CircleBorder(),
                              minimumSize: const Size(30, 30),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          client.name ?? "لا يوجد اسم",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "عميل",
                          style: TextStyle(color: Colors.grey),
                        ),
                        verticalSpace(40),

                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "البريد الإلكتروني",
                            labelStyle: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: client.email ?? "",
                          ),
                        ),
                        verticalSpace(20),

                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "رقم الهاتف",
                            labelStyle: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                            prefixIcon: const Icon(
                              Icons.phone,
                              color: AppColors.primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          controller: TextEditingController(
                            text: client.phone ?? "",
                          ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  currentUserEmail: client.email,
                                  receiverId: "1LgdtODjbta0gnUVWaGNwFqmMTm2",
                                  receiverEmail: "j@j.com",
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text("المحادثات"),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const Scaffold(
            body: Center(child: Text("لا توجد بيانات متاحة")),
          );
        },
      ),
    );
  }
}
