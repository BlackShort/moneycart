import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/app/auth/pages/onboard_page.dart';
import 'package:moneycart/app/base/pages/base_page.dart';
import 'package:moneycart/app/common/pages/otp_page.dart';
import 'package:moneycart/config/routes/route_names.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find<AuthController>();
  late Rx<User?> firebaseUser;
  var verificationId = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isInitialLoading = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    try {
      isInitialLoading.value = true;
      user == null
          ? Get.offAll(() => const OnboardPage())
          : Get.offAll(() => const BasePage());
    } catch (e) {
      print(e.toString());
    } finally {
      isInitialLoading.value = false;
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2));
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          CustomSnackbar.showFailure(
            context: Get.context!,
            title: 'Error',
            message: e.message ?? 'Verification failed',
          );
          isLoading.value = false;
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          Get.to(() => OtpPage(phone: phoneNumber));
          isLoading.value = false;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
          isLoading.value = false;
        },
      );
    } catch (e) {
      print('Sign in error: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: e.toString(),
      );
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    try {
      isLoading.value = true;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      String uid = _auth.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(uid).get();

      if (snapshot.exists) {
        UserModel user = UserModel.fromSnapshot(snapshot);
        await UserPreferences.setUserModel(user);
        await UserPreferences.setUserId(user.id!);
        Get.offAllNamed(AppRoute.base);
      } else {
        CustomSnackbar.showSuccess(
          context: Get.context!,
          title: 'Success',
          message: 'Account created successfully',
        );
        Get.offAllNamed(AppRoute.setProfile);
      }
    } catch (e) {
      print('Login error: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      Get.offAllNamed(AppRoute.onboard);
    } catch (e) {
      print(e.toString());
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Failed to sign out',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
