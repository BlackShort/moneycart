import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/app/common/widgets/custom_text_field.dart';
import 'package:moneycart/app/common/widgets/primary_button.dart';
import 'package:moneycart/app/profile/controllers/profile_controller.dart';
import 'package:moneycart/config/theme/app_pallete.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  final ProfileController _profileController = Get.put(ProfileController());
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _selectedGender;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      UserModel? user = await UserPreferences.getUserModel();
      if (user != null) {
        setState(() {
          _nameController.text = user.name;
          _emailController.text = user.email;
          _addressController.text = user.address;
          _phoneController.text = user.phone;
          _selectedGender = user.gender;
          _profileImageUrl = user.profile;
        });
      }
    } catch (e) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to fetch user profile: ${e.toString()}',
      );
      print('Error fetching user profile: ${e.toString()}');
    }
  }

  Future<void> _selectImageSource() async {
    List<String> avatarUrls = await _profileController.fetchDummyAvatars();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: avatarUrls.length,
                itemBuilder: (context, index) {
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
                        Icon(Icons.photo_library, color: AppPallete.secondary),
                        SizedBox(width: 4),
                        Text('Library',
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
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImageUrl = pickedFile.path;
      });
    } else {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'No image selected',
      );
    }
    Navigator.pop(context);
  }

  Future<void> _handleSave() async {
    print(' hey iam here');
    if (!_validateInputs()) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Please fill all fields',
      );
      return;
    }

    try {
      final uploadedImageUrl = await _handleProfileImageUpload();
      final currentUser = await UserPreferences.getUserModel();

      if (currentUser != null) {
        print(' hey iam inside');
        await _updateUserProfile(currentUser, uploadedImageUrl);
      }
    } catch (e) {
      print('Error updating profile: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to update profile yes: ${e.toString()}',
      );
    }
  }

  bool _validateInputs() {
    return _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _selectedGender != null &&
        _profileImageUrl != null;
  }

  Future<String?> _handleProfileImageUpload() async {
    try {
      if (_profileImageUrl != null && File(_profileImageUrl!).existsSync()) {
        return await _profileController.updateProfilePhoto(_profileImageUrl!);
      }
      print('I got the image: $_profileImageUrl');
      return _profileImageUrl;
    } catch (e) {
      print('Error uploading profile image: ${e.toString()}');
      return '';
    }
  }

  Future<void> _updateUserProfile(
    UserModel currentUser,
    String? uploadedImageUrl,
  ) async {
    try {
      await _profileController.updateUserProfile(
        UserModel(
          id: currentUser.id,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
        profile: uploadedImageUrl ?? '',
          address: _addressController.text,
          gender: _selectedGender!,
        ),
        _phoneController.text,
      );
    } catch (e) {
      print('Error updating profile: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Update',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 19,
          ),
          onPressed: () {
            Get.back();
          },
        ),
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
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Phone Number',
                controller: _phoneController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Email',
                controller: _emailController,
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
              const SizedBox(height: 32),
              Obx(
                () => _profileController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppPallete.primary,
                          ),
                        ),
                      )
                    : PrimaryButton(
                        text: 'Save',
                        onPressed: _handleSave,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
