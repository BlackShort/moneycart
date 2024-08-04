import 'package:get/get.dart';
import 'package:moneycart/core/errors/custom_snackbar.dart';

class Helper {
  bool validateFields(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Validation Error',
        message: 'Please enter your phone number.',
      );
      return false;
    } else if (phoneNumber.length != 10) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Validation Error',
        message: 'Phone number must be exactly 10 digits.',
      );
      return false;
    } else if (!RegExp(r'^\d{10}$').hasMatch(phoneNumber)) {
      CustomSnackbar.showFailure(
        context: Get.context!,
        title: 'Validation Error',
        message: 'Phone number must contain only numeric digits.',
      );
      return false;
    }

    return true;
  }
}
