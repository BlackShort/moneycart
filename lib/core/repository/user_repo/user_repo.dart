import 'package:moneycart/app/auth/models/user_model.dart';
import 'package:moneycart/core/errors/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<String> getUserByPhone(String phone) async {
    try {
      final snapshot =
          await _db.collection('users').where('phone', isEqualTo: phone).get();
      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;
        return userDoc.id;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> saveReferrals(String uuid, String referredUserId) async {
    try {
      DocumentReference ref = _db.collection('referrals').doc(referredUserId);

      DocumentSnapshot doc = await ref.get();

      if (doc.exists) {
        await ref.update({
          'referred_to': FieldValue.arrayUnion([uuid])
        });
      } else {
        await ref.set({
          'referred_to': [uuid]
        });
      }

      // Show success message
      showCustomSnackbar(
        title: 'Success',
        message: 'Referral has been updated!',

      );
    } catch (error) {
      // Show error message
      showCustomSnackbar(
        title: 'Failed',
        message:
            'Failed to update referral. Please check your internet connection and try again',

      );
    }
  }

  Future<void> createUser(UserModel user) async {
    String referredUserId = await getUserByPhone(user.referral!);
    if (referredUserId.isNotEmpty) {
      await saveReferrals(user.id!, referredUserId);
    }
    await _db
        .collection('users')
        .doc(user.id)
        .set(user.toJson())
        .whenComplete(
          () => showCustomSnackbar(
            title: 'Success',
            message: 'Your account has been created!',
          ),
        )
        .catchError((error, stackTrace) {
      showCustomSnackbar(
        title: 'Failed',
        message:
            'Failed to create account. Please check your internet connection and try again',

      );
    });
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection('users').where('email', isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<void> updateUserDetails(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).update(user.toJson());
    } catch (e) {
      showCustomSnackbar(
        title: 'Failed',
        message: 'Failed to update profile. Please try again later.',

      );
    }
  }
}
