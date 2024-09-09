import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class ProfileController extends GetxController {
  static ProfileController instance = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
  }

  // Retrieve user profile from Firestore or UserPreferences
  Future<UserModel?> getUserProfile() async {
    try {
      UserModel? user = await UserPreferences.getUserModel();
      if (user == null) {
        String? userId = await UserPreferences.getUserId();
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(userId).get();
        if (snapshot.exists) {
          user = UserModel.fromSnapshot(snapshot);
          await UserPreferences.setUserModel(user);
        }
            }
      return user;
    } catch (e) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to fetch user profile: ${e.toString()}',
      );
      print('Error fetching user profile: ${e.toString()}');
      return null;
    }
  }

  // Create user profile in Firestore
  Future<void> createUserProfile(UserModel user) async {
    try {
      isLoading.value = true;
      String uid = _auth.currentUser!.uid;
      String? fcmToken = await _firebaseMessaging.getToken();
      user.fcmToken = fcmToken;

      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (!snapshot.exists) {
        await _firestore.collection('users').doc(uid).set(user.toJson());
        await UserPreferences.setUserModel(user);
        CustomSnackbar.showSuccess(
          context: Get.context!,
          title: 'Success',
          message: 'Profile created successfully',
        );
        Get.offAllNamed(AppRoute.base);
      } else {
        CustomSnackbar.showFailure(
          context: Get.context!,
          title: 'Error',
          message: 'Profile already exists',
        );
      }
    } catch (e) {
      print('Error creating user profile: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to create user profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update user profile and phone number
  Future<void> updateUserProfile(UserModel user, String newPhoneNumber) async {
    try {
      isLoading.value = true;
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (!snapshot.exists) {
        CustomSnackbar.showFailure(
          context: Get.context!,
          title: 'Error',
          message: 'Profile does not exist',
        );
        return;
      }

      UserModel currentUser = UserModel.fromSnapshot(snapshot);

      if (currentUser.phone != newPhoneNumber) {
        await _auth.verifyPhoneNumber(
          phoneNumber: newPhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.currentUser!.updatePhoneNumber(credential);
            await _firestore.collection('users').doc(uid).update(user.toJson());
            await UserPreferences.setUserModel(user);
            getUserProfile();
            Get.back();
            CustomSnackbar.showSuccess(
              context: Get.context!,
              title: 'Success',
              message: 'Profile updated successfully',
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            CustomSnackbar.showFailure(
              context: Get.context!,
              title: 'Error',
              message: 'Failed to verify phone number: ${e.message}',
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            this.verificationId.value = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId.value = verificationId;
          },
        );
      } else {
        await _firestore.collection('users').doc(uid).update(user.toJson());
        await UserPreferences.setUserModel(user);
        getUserProfile();
        Get.back();
        CustomSnackbar.showSuccess(
          context: Get.context!,
          title: 'Success',
          message: 'Profile updated successfully',
        );
      }
    } catch (e) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to update user profile',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update phone number with OTP
  Future<void> updatePhoneNumberWithOtp(String smsCode) async {
    try {
      String uid = _auth.currentUser!.uid;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      await _auth.currentUser!.updatePhoneNumber(credential);
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        UserModel user = UserModel.fromSnapshot(
            snapshot.data() as DocumentSnapshot<Map<String, dynamic>>);
        await _firestore.collection('users').doc(uid).update(user.toJson());
        CustomSnackbar.showSuccess(
          context: Get.context!,
          title: 'Success',
          message: 'Phone number updated successfully',
        );
      }
    } catch (e) {
      print('Error updating phone number: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to update phone number',
      );
    }
  }

  // Verify OTP
  Future<void> verifyOtp(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      Get.offAllNamed(AppRoute.base);
    } catch (e) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Invalid OTP',
      );
    }
  }

  // Update profile photo
  Future<String?> updateProfilePhoto(String imagePath) async {
    try {
      isLoading.value = true;
      String uid = _auth.currentUser!.uid;
      File imageFile = File(imagePath);
      TaskSnapshot uploadTask =
          await _storage.ref('profile_photos/$uid.jpg').putFile(imageFile);
      String downloadUrl = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('users').doc(uid).update({
        'profile': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile photo: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to upload profile photo',
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch dummy avatars
  Future<List<String>> fetchDummyAvatars() async {
    try {
      ListResult result =
          await _storage.ref('app_data/placeholder_avatar').listAll();
      List<String> urls =
          await Future.wait(result.items.map((ref) => ref.getDownloadURL()));
      return urls;
    } catch (e) {
      print('Error fetching dummy avatars: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to fetch dummy avatars',
      );
      return [];
    }
  }
}
