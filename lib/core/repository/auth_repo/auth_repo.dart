import 'package:moneycart/app/auth/pages/onboard_page.dart';
import 'package:moneycart/app/base/pages/base_page.dart';
import 'package:moneycart/core/repository/auth_repo/exceptions/signin_exception.dart';
import 'package:moneycart/core/repository/auth_repo/exceptions/signup_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  late final Rx<User?> firebaseUser;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const OnboardPage())
        : Get.offAll(() => const BasePage());
  }

  Future<String> existingUser(String email, String phone) async {
    try {
      // Check for existing user by email
      final emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        return 'email';
      }

      // Check for existing user by phone
      final phoneQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();

      if (phoneQuery.docs.isNotEmpty) {
        return 'phone';
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => const BasePage())
          : Get.to(() => const OnboardPage());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw SignupException.code(e.code);
    } catch (_) {
      throw const SignupException();
    }
  }

  Future<void> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw SigninException.fromCode(e.code);
    } catch (e) {
      throw const SigninException();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw SigninException.fromCode(e.code);
    } catch (_) {
      throw const SigninException();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw SigninException.fromCode(e.code);
    } catch (_) {
      throw const SigninException();
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
