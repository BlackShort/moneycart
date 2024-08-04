import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:moneycart/core/utils/user_preferences.dart';
import 'package:moneycart/core/errors/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class DocController extends GetxController {
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

  Future<void> fetchDocuments() async {
    isLoading.value = true;
    try {
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final docSnapshot = await _firestore
          .collection('docs')
          .doc(userId)
          .collection('documents')
          .get();

      if (docSnapshot.docs.isNotEmpty) {
        _documents.value = docSnapshot.docs.map((doc) => doc.data()).toList();
        _documents.refresh();
        showCustomSnackbar(
          title: 'Success',
          message: 'Documents fetched successfully.',
        );
      }
    } catch (e) {
      print({e.toString()});
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadFile(String downloadUrl) async {
    try {
      final uri = Uri.parse(downloadUrl);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch URL');
      }
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      showCustomSnackbar(
          title: 'Failed',
          message: 'Error downloading file. Please try again.');
    }
  }

  Future<void> showDetails(String year) async {
    try {
      final userId = await UserPreferences.getUserId();
      if (userId == null) {
        throw Exception('User ID not found');
      }
      final docSnapshot = await _firestore.collection('docs').doc(userId).get();
      final docData = docSnapshot.data();
      selectedDetails!.value = docData![year];
      showDetailsTable.value = true;
    } catch (e) {
      showCustomSnackbar(
          title: 'Failed',
          message: 'Error fetching details. Please try again.');
    }
  }

  void hideDetails() {
    showDetailsTable.value = false;
  }
}
