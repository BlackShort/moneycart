import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';
import 'package:moneycart/core/utils/user_preferences.dart';

class ReferralController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> _documents = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool showDetailsTable = false.obs;
  final RxList<dynamic>? selectedDetails = RxList<dynamic>();

  List<Map<String, dynamic>> get documents => _documents;

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> addUserDetails(Map<String, String> data) async {
    try {
      isLoading.value = true;
      final userId = await UserPreferences.getUserId();
      final user = await UserPreferences.getUserModel();
      var docId = user?.referral;
      if (userId == null) {
        throw Exception('User ID not found');
      }

      if (user?.referral != null) {
        await _firestore
            .collection('referrals')
            .doc()
            .update({'referrals': data});
      } else {
        final docRef =
            await _firestore.collection('referrals').add({'referrals': data});
        await _firestore.collection('users').doc(userId).update({
          'referral': docRef.id,
        });
        docId = docRef.id;
      }

      final docSnapshot =
          await _firestore.collection('referrals').doc(docId).get();
      if (docSnapshot.exists) {
        final referralsData =
            docSnapshot.data()?['referrals'] as List<dynamic>?;
        if (referralsData != null && referralsData.isNotEmpty) {
          _documents.value = referralsData
              .map((data) => data as Map<String, dynamic>)
              .toList();
          _documents.refresh();
          CustomSnackbar.showSuccess(
            context: Get.context!,
            title: 'Success',
            message: 'Documents fetched successfully.',
          );
        } else {
          CustomSnackbar.showFailure(
            context: Get.context!,
            title: 'Error',
            message: 'No referrals found.',
          );
        }
      } else {
        CustomSnackbar.showFailure(
          context: Get.context!,
          title: 'Error',
          message: 'No referral document found.',
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final docRef = await _firestore.collection('users').doc(userId).get();
      final referralId = docRef.data()?['referral'];
      if (referralId == null) {
        throw Exception('Referral ID not found for the user');
      }

      final docSnapshot =
          await _firestore.collection('referrals').doc(referralId).get();
      if (docSnapshot.exists) {
        final referralsData =
            docSnapshot.data()?['referrals'] as List<dynamic>?;
        if (referralsData != null && referralsData.isNotEmpty) {
          _documents.value = referralsData
              .map((data) => data as Map<String, dynamic>)
              .toList();
          _documents.refresh();
          CustomSnackbar.showSuccess(
            context: Get.context!,
            title: 'Success',
            message: 'Referrals fetched successfully',
          );
        } else {
          CustomSnackbar.showFailure(
            context: Get.context!,
            title: 'Error',
            message: 'No referrals found',
          );
        }
      } else {
        CustomSnackbar.showFailure(
          context: Get.context!,
          title: 'Error',
          message: 'No referral document found.',
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Error',
        message: 'Error: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
