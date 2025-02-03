import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moneycart/core/errors/snackbar.dart';

class PfController extends GetxController {
  static PfController get instance => Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _authRepo = FirebaseAuth.instance.currentUser;
  RxBool isLoading = false.obs;
  RxBool previousYear = false.obs;
  late DocumentSnapshot<Map<String, dynamic>> documentSnapshot;

  // Fetching OTP State either it's true or false
  Future<Map<String, dynamic>?> fetchOTPState() async {
    try {
      final userId = _authRepo?.uid;
      if (userId == null) {
        return null;
      }
      final documentSnapshot =
          await firestore.collection('tds_state').doc(userId).get();
      return documentSnapshot.data();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Submit TDS form data
  Future<void> submitFormData(
    String firstNameController,
    String lastNameController,
    String emailController,
    String phoneController,
    String dobController,
    String aadharController,
    String pinCodeController,
    String addressController,
    String bankAccountController,
    String bankIFSCController,
    String panController,
  ) async {
    try {
      isLoading.value = true;
      final userId = _authRepo?.uid;
      await firestore.collection('tds_forms').doc(userId).set({
        'aadhar': aadharController,
        'address': addressController,
        'bank_account': bankAccountController,
        'bank_ifsc': bankIFSCController,
        'dob': dobController,
        'email': emailController,
        'first_name': firstNameController,
        'last_name': lastNameController,
        'pan': panController,
        'phone': phoneController,
        'pin_code': pinCodeController,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });

      await firestore.collection('tds_state').doc(userId).set({
        'bankconfirm': false,
        'enableOtp': false,
        'fileTds': false,
        'finalOtp': false,
        'finalotpstatus': false,
        'incomesiteregistration': false,
        'paymentstatus': false,
        'processing': false,
        'registraionOtp': false,
        'showOtp': true,
        'tdsA26s': false,
        'tdsDetails': false,
        'tdsformfilluped': true,
      });

      // Get.off(
      //   () => const SuccessPage(
      //     successMessage:
      //         "Your request has been successfully submitted. \nMoneyCart Team would connect with you shortly to complete the registration on Income tax site.",
      //   ),
      // );
    } catch (e) {
      showCustomSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  // Submit OTP
  Future<void> submitOTPData(String emailOTP, String phoneOTP) async {
    try {
      isLoading.value = true;
      final userId = _authRepo?.uid;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      await firestore.collection('tds_otp').doc(userId).set({
        'userId': userId,
        'emailotp': emailOTP,
        'phoneotp': phoneOTP,
      });

      await firestore.collection('tds_state').doc(userId).update({
        'bankconfirm': true,
        'enableOtp': false,
        'showOtp': false,
      });

      // Get.off(
      //   () => SuccessPage(
      //       buttonText: 'Continue',
      //       callbackAction: () => Get.off(() => const TdsBankOtp()),
      //       successMessage:
      //           "OTP has been submitted successfully. \n\nPlease confirm your bank account details by proceeding."),
      // );
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong!');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetching Bank Details to confirm Bank Account
  Future<Map<String, dynamic>?> fetchBankData() async {
    try {
      final userId = _authRepo?.uid;
      if (userId == null) {
        return null;
      }
      final documentSnapshot =
          await firestore.collection('tds_forms').doc(userId).get();
      return documentSnapshot.data();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Confirm Bank Account
  Future<void> confirmBank(String otp) async {
    try {
      isLoading.value = true;
      final userId = _authRepo?.uid;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      await firestore.collection('tds_bank_otp').doc(userId).set({
        'userId': userId,
        'otp': otp,
      });

      await firestore.collection('tds_state').doc(userId).update({
        'bankconfirm': false,
        'enableOtp': false,
        'tdsDetails': true,
      });

      // Get.off(
      //   () => const SuccessPage(
      //       successMessage:
      //           "Congratulations!!! Your registration is complete on the income tax site. \n\n MoneyCart team would share the TDS Refund amount with you shortly. \n\nKeep reviewing the 'Document' section on the App."),
      // );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Something went wrong!',
      );
    } finally {
      isLoading.value = false;
    }
  }

// Fetching TDS Details Data for table
  Future<DocumentSnapshot<Map<String, dynamic>>> fetchTdsDetails() async {
    final userId = _authRepo?.uid;
    if (userId == null) {
      throw Exception('User ID is null');
    }
    documentSnapshot =
        await firestore.collection('tds_details').doc(userId).get();
    return documentSnapshot;
  }

  // Make Payment to file TDS Refund
  Future<void> makePayment() async {
    try {
      isLoading.value = true;
      final userId = _authRepo?.uid;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      await firestore.collection('tds_state').doc(userId).update({
        'enableOtp': false,
        'finalOtp': true,
        'paymentstatus': true,
        'tdsDetails': false,
      });

      if (previousYear.value) {
        try {
          await firestore.collection('tds_refund_Years').doc(userId).set({
            'currentYear': true,
            'previousYear': previousYear.value,
            'userId': userId,
          });
        } catch (e) {
          showCustomSnackbar(title: 'Failed', message: 'Something went wrong!');
        }
      }

      // Get.off(
      //   () => SuccessPage(
      //       callbackAction: () => Get.off(() => const TdsFinalOtp()),
      //       successMessage:
      //           "Thanks for the payment !!!. \nMoneyCart team would connect with you within next 24 hours to file the Income Tax return and claim TDS refund.\n\n Please share the OTP for validation when you are notified"),
      // );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Something went wrong!',
      );
    } finally {
      previousYear.value = false;
      isLoading.value = false;
    }
  }

  // Final OTP Submission (E-Validation)
  Future<void> eValidation(String otp) async {
    try {
      isLoading.value = true;
      final userId = _authRepo?.uid;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      await firestore.collection('tds_refund_otp').doc(userId).set({
        'uerid': userId,
        'otp': otp,
      });

      await firestore.collection('tds_state').doc(userId).update({
        'enableOtp': false,
        'finalOtp': false,
        'finalotpstatus': true,
        'processing': true,
      });

      // Get.off(
      //   () => SuccessPage(
      //     redirect: true,
      //     callbackAction: () => Get.offAll(() => const BasePage()),
      //     successMessage:
      //         " Congratulations !!! Your ITR return has been successfully verified. \nYou would get the TDS refund in your bank account in 7-30 working days.\n\nNow Earn more by Referring MoneyCart to your friends and help them claim their refund.",
      //   ),
      // );
    } catch (e) {
      showCustomSnackbar(
        title: 'Error',
        message: 'Something went wrong!',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
