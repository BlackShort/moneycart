import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/app/common/widgets/custom_text_field.dart';
import 'package:moneycart/app/common/widgets/loading_button.dart';
import 'package:moneycart/app/profile/controllers/profile_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSetup extends StatefulWidget {
  const ProfileSetup({super.key});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final ProfileController _profileController = Get.put(ProfileController());
  final User? user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selectImageSource() async {
    List<String> avatarUrls = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // Fetch avatars asynchronously after opening the bottom sheet.
            _profileController.fetchDummyAvatars().then((fetchedUrls) {
              setState(() {
                avatarUrls = fetchedUrls;
              });
            });

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: avatarUrls.isNotEmpty ? avatarUrls.length : 8,
                    itemBuilder: (context, index) {
                      if (avatarUrls.isEmpty) {
                        // Show shimmer effect while avatars are loading
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      } else {
                        String url = avatarUrls[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _profileImageUrl = url;
                            });
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: CachedNetworkImageProvider(url),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library,
                                color: AppPallete.secondary),
                            SizedBox(width: 4),
                            Text('Gallary',
                                style: TextStyle(color: AppPallete.secondary)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: AppPallete.secondary),
                            SizedBox(width: 4),
                            Text('Camera',
                                style: TextStyle(color: AppPallete.secondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImageUrl = pickedFile.path;
      });
    }
    Navigator.pop(context); // Close the bottom sheet
  }

  Future<void> _handleSave() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _selectedGender == null ||
        _addressController.text.isEmpty) {
      CustomSnackbar.showFailure(
        context: context,
        title: 'Error',
        message: 'Please fill all fields',
      );
      return;
    }

    String? uploadedImageUrl;
    if (_profileImageUrl != null) {
      if (File(_profileImageUrl!).existsSync()) {
        uploadedImageUrl =
            await _profileController.updateProfilePhoto(_profileImageUrl!);
      } else if (Uri.tryParse(_profileImageUrl!)?.isAbsolute ?? false) {
        uploadedImageUrl = _profileImageUrl;
      }
    }

    await _profileController.createUserProfile(
      UserModel(
        id: user!.uid,
        name: _nameController.text.trim().toUpperCase(),
        email: _emailController.text.trim().toLowerCase(),
        profile: uploadedImageUrl ?? '',
        phone: user!.phoneNumber!,
        address: _addressController.text.trim(),
        gender: _selectedGender!,
        fcmToken: '',
        referral: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            color: AppPallete.secondary,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        leadingWidth: 16,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: (_profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty)
                          ? Colors.transparent
                          : Colors.grey[300],
                      child: (_profileImageUrl != null &&
                              _profileImageUrl!.isNotEmpty)
                          ? ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: _profileImageUrl!,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  size: 55,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey[600],
                            ),
                    ),
                  ),
                  Positioned(
                    right: MediaQuery.of(context).size.width * 0.33,
                    bottom: 5,
                    child: GestureDetector(
                      onTap: _selectImageSource,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomTextField(
                labelText: 'Full Name',
                controller: _nameController,
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Phone Number',
                controller: TextEditingController(text: user?.phoneNumber),
                enabled: false,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email Address',
                controller: _emailController,
                letterSpacing: 2,
                textCapitalization: TextCapitalization.none,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Full Address',
                controller: _addressController,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: LoadingButton(
                    text: 'Save',
                    isLoading: _profileController.isLoading.value,
                    onPressed: _handleSave,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
